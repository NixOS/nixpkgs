{ build-asdf-system, spec, quicklispPackagesFor, stdenv, pkgs, ... }:

let

  inherit (pkgs.lib)
    head
    makeLibraryPath
    makeSearchPath
    setAttr
    hasAttr
    optionals
    hasSuffix
    splitString
    remove
  ;

  # Used by builds that would otherwise attempt to write into storeDir.
  #
  # Will run build two times, keeping all files created during the
  # first run, exept the FASL's. Then using that directory tree as the
  # source of the second run.
  #
  # E.g. cl-unicode creating .txt files during compilation
  build-with-compile-into-pwd = args:
    let
      build = (build-asdf-system (args // { version = args.version + "-build"; }))
        .overrideAttrs(o: {
          buildPhase = with builtins; ''
            mkdir __fasls
            export ASDF_OUTPUT_TRANSLATIONS="$(pwd):$(pwd)/__fasls:${storeDir}:${storeDir}"
            export CL_SOURCE_REGISTRY=$CL_SOURCE_REGISTRY:$(pwd)//
            ${o.pkg}/bin/${o.program} ${toString (o.flags or [])} < ${o.buildScript}
          '';
          installPhase = ''
            mkdir -pv $out
            rm -rf __fasls
            cp -r * $out
          '';
        });
    in build-asdf-system (args // {
      # Patches are already applied in `build`
      patches = [];
      src = build;
    });

  # Makes it so packages imported from Quicklisp can be re-used as
  # lispLibs ofpackages in this file.
  ql = quicklispPackagesFor spec;

  packages = ql.overrideScope (self: super: {

  cl-environments = super.cl-environments.overrideLispAttrs (old: {
    patches = old.patches or [] ++ [
      # Needed because SB-INT:TRULY-DYNAMIC-EXTENT has been removed since sbcl 2.3.10.
      # The update isn't available on quicklisp yet, but we can fetch from upstream directly
      (pkgs.fetchpatch {
        url = "https://github.com/alex-gutev/cl-environments/commit/1bd7ecf68adeaf654616c6fb763c1239e0f2e221.patch";
        sha256 = "sha256-i6KdthYqPlJPvxM2c2kossHYvXNhpZHl/7NzELNrOHU=";
      })
    ];
  });

  cl-unicode = build-with-compile-into-pwd {
    inherit (super.cl-unicode) pname version src systems;
    lispLibs = super.cl-unicode.lispLibs ++ [ self.flexi-streams ];
  };

  dissect = super.dissect.overrideAttrs {
    version = "1.0.0-trunk";
    src = pkgs.fetchFromGitHub {
      owner = "Shinmera";
      repo = "dissect";
      rev = "a70cabcd748cf7c041196efd711e2dcca2bbbb2c";
      hash = "sha256-WXv/jbokgKJTc47rBjvOF5npnqDlsyr8oSXIzN/7ofo=";
    };
  };

  cl-gobject-introspection = super.cl-gobject-introspection.overrideLispAttrs (o: {
    postPatch = ''
      substituteInPlace src/init.lisp \
        --replace sb-ext::set-floating-point-modes sb-int:set-floating-point-modes
    '';
  });

  jzon = super.com_dot_inuoe_dot_jzon;

  cl-notify = build-asdf-system {
    pname = "cl-notify";
    version = "20080904-138ca7038";
    src = pkgs.fetchzip {
      url = "https://repo.or.cz/cl-notify.git/snapshot/138ca703861f4a1fbccbed557f92cf4d213668a1.tar.gz";
      sha256 = "0k6ns6fzvjcbpsqgx85r4g5m25fvrdw9481i9vyabwym9q8bbqwx";
    };
    lispLibs = [
      self.cffi
    ];
    nativeLibs = [
      pkgs.libnotify
    ];
  };

  cl-liballegro-nuklear = build-with-compile-into-pwd {
    inherit (super.cl-liballegro-nuklear) pname version src;
    nativeBuildInputs = [ pkgs.allegro5 ];
    nativeLibs = [ pkgs.allegro5 ];
    lispLibs = super.cl-liballegro-nuklear.lispLibs ++ [ self.cl-liballegro ];
    patches = [ ./patches/cl-liballegro-nuklear-missing-dll.patch ];
  };

  lessp = build-asdf-system {
    pname = "lessp";
    version = "0.2-f8a9e4664";
    src = pkgs.fetchzip {
      url = "https://github.com/facts-db/cl-lessp/archive/632217602b85b679e8d420654a0aa39e798ca3b5.tar.gz";
      sha256 = "0i3ia14dzqwjpygd0zn785ff5vqnnmkn75psfpyx0ni3jr71lkq9";
    };
  };

  rollback = build-asdf-system {
    pname = "rollback";
    version = "0.1-5d3f21fda";
    src = pkgs.fetchzip {
      url = "https://github.com/facts-db/cl-rollback/archive/5d3f21fda8f04f35c5e9d20ee3b87db767915d15.tar.gz";
      sha256 = "12dpxsbm2al633y87i8p784k2dn4bbskz6sl40v9f5ljjmjqjzxf";
    };
  };

  facts = build-asdf-system {
    pname = "facts";
    version = "0.1-632217602";
    src = pkgs.fetchzip {
      url = "https://beta.quicklisp.org/archive/cl-facts/2022-11-06/cl-facts-20221106-git.tgz";
      sha256 = "sha256-PBpyyJYkq1NjKK9VikSAL4TmrGRwUJlEWRSeKj/f4Sc=";
    };
    lispLibs = [ self.lessp self.rollback self.local-time ];
  };

  cl-fuse = build-with-compile-into-pwd {
    inherit (super.cl-fuse) pname version src lispLibs;
    nativeBuildInputs = [ pkgs.fuse ];
    nativeLibs = [ pkgs.fuse ];
  };

  cl-containers = build-asdf-system {
    inherit (super.cl-containers) pname version src;
    lispLibs = super.cl-containers.lispLibs ++ [ self.moptilities ];
    systems = [ "cl-containers" "cl-containers/with-moptilities" ];
  };

  swank = build-with-compile-into-pwd rec {
    inherit (super.swank) pname lispLibs;
    version = "2.29.1";
    src = pkgs.fetchFromGitHub {
      owner = "slime";
      repo = "slime";
      rev =  "v${version}";
      hash = "sha256-5hNB5XxbTER4HX3dn4umUGnw6UeiTQkczmggFz4uWoE=";
    };
    systems = [ "swank" "swank/exts" ];
    patches = [ ./patches/swank-pure-paths.patch ];
    postConfigure = ''
      substituteAllInPlace swank-loader.lisp
    '';
  };

  slynk = build-asdf-system {
    pname = "slynk";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "joaotavora";
      repo = "sly";
      rev =  "ba40c8f054ec3b7040a6c36a1ef3e9596b936421";
      hash = "sha256-hoaCZtyezuXptDPnAvBTT0SZ14M9Ifrmki3beBOwFmI=";
    };
    systems = [
      "slynk" "slynk/arglists" "slynk/fancy-inspector"
      "slynk/package-fu" "slynk/mrepl" "slynk/trace-dialog"
      "slynk/profiler" "slynk/stickers" "slynk/indentation"
      "slynk/retro"
    ];
  };

  cephes = build-with-compile-into-pwd {
    inherit (super.cephes) pname version src lispLibs;
    patches = [ ./patches/cephes-make.patch ];
    postConfigure = ''
      substituteAllInPlace cephes.asd
    '';
  };

  clx-truetype = build-asdf-system {
    pname = "clx-truetype";
    version = "20160825-git";
    src = pkgs.fetchzip {
      url = "http://beta.quicklisp.org/archive/clx-truetype/2016-08-25/clx-truetype-20160825-git.tgz";
      sha256 = "079hyp92cjkdfn6bhkxsrwnibiqbz4y4af6nl31lzw6nm91j5j37";
    };
    lispLibs = with self; [
      alexandria bordeaux-threads cl-aa cl-fad cl-paths cl-paths-ttf
      cl-store cl-vectors clx trivial-features zpb-ttf
    ];
  };

  mathkit = build-asdf-system {
    inherit (super.mathkit) pname version src asds ;
    lispLibs = super.mathkit.lispLibs ++ [ super.sb-cga ];
  };

  stumpwm = super.stumpwm.overrideLispAttrs (o: rec {
    version = "22.11";
    src = pkgs.fetchFromGitHub {
      owner = "stumpwm";
      repo = "stumpwm";
      rev = version;
      hash = "sha256-zXj17ucgyFhv7P0qEr4cYSVRPGrL1KEIofXWN2trr/M=";
    };
    buildScript = pkgs.writeText "build-stumpwm.lisp" ''
      (load "${super.stumpwm.asdfFasl}/asdf.${super.stumpwm.faslExt}")

      (asdf:load-system 'stumpwm)

      ;; Prevents package conflict error
      (when (uiop:version<= "3.1.5" (asdf:asdf-version))
        (uiop:symbol-call '#:asdf '#:register-immutable-system :stumpwm)
        (dolist (system-name (uiop:symbol-call '#:asdf
                                               '#:system-depends-on
                                               (asdf:find-system :stumpwm)))
          (uiop:symbol-call '#:asdf '#:register-immutable-system system-name)))

      ;; Prevents "cannot create /homeless-shelter" error
      (asdf:disable-output-translations)

      (sb-ext:save-lisp-and-die
        "stumpwm"
        :executable t
        :purify t
        #+sb-core-compression :compression
        #+sb-core-compression t
        :toplevel #'stumpwm:stumpwm)
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp -v stumpwm $out/bin
    '';
  });

  stumpwm-unwrapped = super.stumpwm;

  clfswm = super.clfswm.overrideAttrs (o: rec {
    buildScript = pkgs.writeText "build-clfswm.lisp" ''
      (load "${o.asdfFasl}/asdf.${o.faslExt}")
      (asdf:load-system 'clfswm)
      (sb-ext:save-lisp-and-die
        "clfswm"
        :executable t
        #+sb-core-compression :compression
        #+sb-core-compression t
        :toplevel #'clfswm:main)
    '';
    installPhase = o.installPhase + ''
      mkdir -p $out/bin
      mv $out/clfswm $out/bin
    '';
  });

  magicl = build-with-compile-into-pwd {
    inherit (super.magicl) pname version src lispLibs;
    nativeBuildInputs = [ pkgs.gfortran ];
    nativeLibs = [ pkgs.openblas ];
    patches = [ ./patches/magicl-dont-build-fortran-twice.patch ];
  };

  cl-glib = build-asdf-system {
    pname = "cl-glib";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "bohonghuang";
      repo = "cl-glib";
      rev = "84b128192d6b11cf03f1150e474a23368f07edff";
      hash = "sha256-A56Yz+W4n1rAxxZg15zfkrLMbKMEG/zsWqaX7+kx4Qg=";
    };
    lispLibs = with self; [
      cl-gobject-introspection-wrapper
      bordeaux-threads
    ];
  };

  cl-glib_dot_gio = build-asdf-system {
    pname = "cl-glib.gio";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "bohonghuang";
      repo = "cl-glib";
      rev = "84b128192d6b11cf03f1150e474a23368f07edff";
      hash = "sha256-A56Yz+W4n1rAxxZg15zfkrLMbKMEG/zsWqaX7+kx4Qg=";
    };
    lispLibs = with self; [
      cl-gobject-introspection-wrapper
    ];
  };

  cl-gtk4 = build-asdf-system {
    pname = "cl-gtk4";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "bohonghuang";
      repo = "cl-gtk4";
      rev = "e18f621b996fd986d9829d590203c690440dee64";
      hash = "sha256-++qydw6db4O3m+DAjutVPN8IuePOxseo9vhWEvwiR6E=";
    };
    lispLibs = with self; [
      cl-gobject-introspection-wrapper
      cl-glib
      cl-glib_dot_gio
    ];
    nativeBuildInputs = [
      pkgs.gobject-introspection
      pkgs.gtk4
    ];
    nativeLibs = [
      pkgs.gtk4
    ];
  };

  cl-gtk4_dot_adw = build-asdf-system {
    pname = "cl-gtk4.adw";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "bohonghuang";
      repo = "cl-gtk4";
      rev = "e18f621b996fd986d9829d590203c690440dee64";
      hash = "sha256-++qydw6db4O3m+DAjutVPN8IuePOxseo9vhWEvwiR6E=";
    };
    lispLibs = with self; [
      cl-gobject-introspection-wrapper
      cl-gtk4
    ];
    nativeBuildInputs = [
      pkgs.libadwaita
    ];
    nativeLibs = [
      pkgs.libadwaita
    ];
  };

  cl-gtk4_dot_webkit2 = build-asdf-system {
    pname = "cl-gtk4.webkit2";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "bohonghuang";
      repo = "cl-gtk4";
      rev = "e18f621b996fd986d9829d590203c690440dee64";
      hash = "sha256-++qydw6db4O3m+DAjutVPN8IuePOxseo9vhWEvwiR6E=";
    };
    lispLibs = with self; [
      cl-gobject-introspection-wrapper
      cl-gtk4
    ];
    nativeBuildInputs = [
      pkgs.webkitgtk_6_0
    ];
    nativeLibs = [
      pkgs.webkitgtk_6_0
    ];
    # Requires old webkitgtk_5_0 which was replaced by webkitgtk_6_0
    meta.broken = true;
  };

  cl-avro = build-asdf-system {
    pname = "cl-avro";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "SahilKang";
      repo = "cl-avro";
      rev = "7d624253e98afb987a01729bd72c99bae02f0d7d";
      hash = "sha256-AlTn+Q1gKnAFEfcnz9+VeHz681pPIirg2za3VXYiNWk=";
    };
    lispLibs = with self; [
      alexandria
      babel
      chipz
      closer-mop
      ieee-floats
      flexi-streams
      local-time
      local-time-duration
      md5
      salza2
      st-json
      time-interval
      trivial-extensible-sequences
    ];
  };

  trivial-clock = build-asdf-system {
    pname = "trivial-clock";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "ak-coram";
      repo = "cl-trivial-clock";
      rev = "641e12ab1763914996beb1ceee67aabc9f1a3b1e";
      hash = "sha256-mltQEJ2asxyQ/aS/9BuWmN3XZ9bGmmkopcF5YJU1cPk=";
    };
    systems = [ "trivial-clock" "trivial-clock/test" ];
    lispLibs = [ self.cffi self.fiveam ];
  };

  frugal-uuid = build-asdf-system {
    pname = "frugal-uuid";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "ak-coram";
      repo = "cl-frugal-uuid";
      rev = "be27972333a16fc3f16bc7fbf9e3013b2123d75c";
      hash = "sha256-rWO43vWMibF8/OxL70jle5nhd9oRWC7+MI44KWrQD48=";
    };
    systems = [ "frugal-uuid"
                "frugal-uuid/non-frugal"
                "frugal-uuid/benchmark"
                "frugal-uuid/test" ];
    lispLibs = with self; [
      babel
      bordeaux-threads
      fiveam
      ironclad
      trivial-benchmark
      trivial-clock
    ];
  };

  duckdb = build-asdf-system {
    pname = "duckdb";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "ak-coram";
      repo = "cl-duckdb";
      rev = "3ed1df5ba5c738a0b7fed7aa73632ec86f558d09";
      hash = "sha256-AJMxhtDACe6WTwEOxLsC8y6uBaPqjt8HLRw/eIZI02E=";
    };
    systems = [ "duckdb" "duckdb/test" "duckdb/benchmark" ];
    lispLibs = with self; [
      bordeaux-threads
      cffi-libffi
      cl-ascii-table
      cl-spark
      cl-ppcre
      frugal-uuid
      let-plus
      local-time
      local-time-duration
      periods
      float-features
    ];
    nativeLibs = with pkgs; [
      duckdb libffi
    ];
  };

  polyclot = build-asdf-system {
    pname = "polyclot";
    version = "trunk";
    src = pkgs.fetchfossil {
      url = "https://fossil.turtleware.eu/polyclot";
      rev = "e678b3c3e002f53b446780406c9ed13f8451309d22a1dc50ced4dbeedf08a1ec";
      sha256 = "sha256-J08bU9HSVbzEivYtQsyIYPZJTrugj+jJSa4LglS0Olg=";
    };
    systems = [ "eu.turtleware.polyclot" "eu.turtleware.polyclot/demo" ];
    lispLibs = with self; [ clim mcclim mcclim-layouts ];
  };

  kons-9 = build-asdf-system rec {
    pname = "kons-9";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "kaveh808";
      repo = "kons-9";
      rev = "95ad44fac0566f445c4b7bd040339dcff75ee992";
      sha256 = "19rl7372j9f1cv2kl55r8vyf4dhcz4way4hkjgysbxzrb1psp17n";
    };
    systems = [ "kons-9" "kons-9/testsuite" ];
    lispLibs = with self; [
      closer-mop trivial-main-thread trivial-backtrace cffi cl-opengl cl-glu
      cl-glfw3 cl-paths-ttf zpb-ttf cl-vectors origin clobber
      org_dot_melusina_dot_confidence
    ];
  };

  sb-cga = build-asdf-system {
    pname = "sb-cga";
    version = "1.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "nikodemus";
      repo = "sb-cga";
      rev = "9a554ea1c01cac998ff7eaa5f767bc5bcdc4c094";
      sha256 = "sha256-iBM+VXu6JRqGmeIFzfXbGot+elvangmfSpDB7DjFpPg";
    };
    lispLibs = [ self.alexandria ];
  };

  nsb-cga = super.nsb-cga.overrideLispAttrs (oa: {
    lispLibs = oa.lispLibs ++ [ self.sb-cga ];
  });

  qlot-cli = build-asdf-system rec {
    pname = "qlot";
    version = "1.5.2";

    src = pkgs.fetchFromGitHub {
      owner = "fukamachi";
      repo = "qlot";
      rev = "refs/tags/${version}";
      hash = "sha256-j9iT25Yz9Z6llCKwwiHlVNKLqwuKvY194LrAzXuljsE=";
    };

    lispLibs = with self; [
      archive
      deflate
      dexador
      fuzzy-match
      ironclad
      lparallel
      yason
    ];

    nativeLibs = [
      pkgs.openssl
    ];

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    buildScript = pkgs.writeText "build-qlot-cli" ''
      (load "${self.qlot-cli.asdfFasl}/asdf.${self.qlot-cli.faslExt}")
      (asdf:load-system :qlot/command)
      (asdf:load-system :qlot/subcommands)

      ;; Use uiop:dump-image instead of sb-ext:dump-image for the image restore hooks
      (setf uiop:*image-entry-point* #'qlot/cli:main)
      (uiop:dump-image "qlot"
                       :executable t
                       #+sb-core-compression :compression
                       #+sb-core-compression t)
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp qlot.asd $out
      rm *.asd
      cp -r * $out

      mv $out/qlot $out/bin
      wrapProgram $out/bin/qlot \
        --prefix LD_LIBRARY_PATH : $LD_LIBRARY_PATH

      runHook postInstall
    '';

    meta.mainProgram = "qlot";
  };

  misc-extensions = super.misc-extensions.overrideLispAttrs (old: rec {
    version = "4.0.3";
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.common-lisp.net";
      owner = "misc-extensions";
      repo = "misc-extensions";
      rev = "v${version}";
      hash = "sha256-bDNI4mIaNw/rf7ZwvwolKo6+mUUxsgubGUd/988sHAo=";
    };
  });

  fset = super.fset.overrideLispAttrs (old: rec {
    version = "1.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "slburson";
      repo = "fset";
      rev = "v${version}";
      hash = "sha256-alO8Ek5Xpyl5N99/LgyIZ50aoRbY7bKh3XBntFV6Q5k=";
    };
    lispLibs = with super; [
      self.misc-extensions
      mt19937
      named-readtables
    ];
    meta = {
      description = "functional collections library";
      homepage = "https://gitlab.common-lisp.net/fset/fset/-/wikis/home";
      license = pkgs.lib.licenses.llgpl21;
    };
  });

  coalton = build-asdf-system {
    pname = "coalton";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "coalton-lang";
      repo = "coalton";
      rev = "05111b8a59e3f7346b175ce1ec621bff588e1e1f";
      hash = "sha256-L9o7Y3zDx9qLXGe/70c1LWEKUWsSRgBQru66mIuaCFw=";
    };
    lispLibs = with super; [
      alexandria
      eclector-concrete-syntax-tree
      fiasco
      float-features
      self.fset
      named-readtables
      trivial-garbage
    ];
    nativeLibs = [ pkgs.mpfr ];
    systems = [ "coalton" "coalton/tests" ];
    meta = {
      description = "statically typed functional programming language that supercharges Common Lisp";
      homepage = "https://coalton-lang.github.io";
      license = pkgs.lib.licenses.mit;
    };
  };

  });

in packages
