{ build-asdf-system, spec, quicklispPackagesFor, stdenv, pkgs, ... }:

let

  inherit (pkgs.lib)
    head
    makeLibraryPath
    makeSearchPath
    setAttr
    hasAttr
    optionals
    optionalAttrs
    isDerivation
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
      args' = if isDerivation args then args.drvAttrs else args;
      build = (build-asdf-system (args' // { version = args'.version + "-build"; }))
        .overrideAttrs(o: {
          buildPhase = with builtins; ''
            runHook preBuild

            mkdir __fasls
            export ASDF_OUTPUT_TRANSLATIONS="$(pwd):$(pwd)/__fasls:${storeDir}:${storeDir}"
            export CL_SOURCE_REGISTRY=$CL_SOURCE_REGISTRY:$(pwd)//
            ${o.pkg}/bin/${o.program} ${toString (o.flags or [])} < ${o.buildScript}

            runHook postBuild
          '';
          installPhase = ''
            runHook preInstall

            mkdir -pv $out
            rm -rf __fasls
            cp -r * $out

            runHook postInstall
          '';
        });
    in build-asdf-system (args' // {
      # Patches are already applied in `build`
      patches = [];
      postPatch = "";
      src = build;
    });

  # Makes it so packages imported from Quicklisp can be re-used as
  # lispLibs ofpackages in this file.
  ql = quicklispPackagesFor spec;

  packages = ql.overrideScope (self: super: {

  cl-unicode = build-with-compile-into-pwd {
    inherit (super.cl-unicode) pname version src systems;
    lispLibs = super.cl-unicode.lispLibs ++ [ self.flexi-streams ];
  };

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

  cl-liballegro-nuklear = build-with-compile-into-pwd super.cl-liballegro-nuklear;

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
    postPatch = ''
      find \( -name '*.dll' -o -name '*.dylib' -o -name '*.so' \) -delete
    '';
    postConfigure = ''
      substituteAllInPlace cephes.asd
    '';
    postInstall = ''
      find $out -name '*.o' -delete
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
  };

  cl-gtk4 = build-asdf-system {
    pname = "cl-gtk4";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "bohonghuang";
      repo = "cl-gtk4";
      rev = "ff60e3495cdbba5c09d0bb8aa49f3184cc060c8e";
      hash = "sha256-06cyPf+5z+GE3YvZEJ67kC281nkwRz/hoaykTISsni0=";
    };
    lispLibs = with self; [
      cl-gobject-introspection-wrapper
      cl-glib
      cl-gio
      cl-gobject
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
    version = self.cl-gtk4.version;
    src = self.cl-gtk4.src;
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

  cl-gtk4_dot_webkit = build-asdf-system {
    pname = "cl-gtk4.webkit";
    version = self.cl-gtk4.version;
    src = self.cl-gtk4.src;
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
  };

  cl-avro = build-asdf-system {
    pname = "cl-avro";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "SahilKang";
      repo = "cl-avro";
      rev = "b8fa26320fa0ae88390215140d57f9cca937f691";
      hash = "sha256-acXsotvKWuffrLbrG9YJ8yZc5E6WC8N0qCFCAiX6N0Q=";
    };
    lispLibs = with self; [
      alexandria babel chipz closer-mop ieee-floats flexi-streams local-time
      local-time-duration md5 salza2 st-json time-interval
      trivial-extensible-sequences
    ];
  };

  frugal-uuid = super.frugal-uuid.overrideLispAttrs (o: {
    systems = [
      "frugal-uuid"
      "frugal-uuid/non-frugal"
      "frugal-uuid/benchmark"
      "frugal-uuid/test"
    ];
    lispLibs = o.lispLibs ++ (with self; [
      ironclad
      babel
      trivial-clock
      trivial-benchmark
      fiveam
    ]);
  });

  duckdb = super.duckdb.overrideLispAttrs (o: {
    systems = [ "duckdb" "duckdb/test" "duckdb/benchmark" ];
  });

  polyclot = build-asdf-system {
    pname = "polyclot";
    version = "trunk";
    src = pkgs.fetchfossil {
      url = "https://fossil.turtleware.eu/fossil.turtleware.eu/polyclot";
      rev = "18500c968b1fc1e2a915b5c70b8cddc4a2b54de51da4eedc5454e42bfea3b479";
      sha256 = "sha256-KgBL1QQN4iG6d8E9GlKAuxSwkrY6Zy7e1ZzEDGKad+A=";
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
      rev = "08770e7fbb839b91fd035f1cd4a50ecc81b42d57";
      sha256 = "sha256-Tit/qmOU5+zp43/ecIXGbh4CtgWzltWM7tHdVWkga0k=";
    };
    systems = [ "kons-9" "kons-9/testsuite" ];
    patches = [ ./patches/kons-9-fix-testsuite-compilation.patch ];
    lispLibs = with self; [
      closer-mop trivial-main-thread trivial-backtrace cffi cl-opengl cl-glu
      cl-glfw3 cl-paths-ttf zpb-ttf cl-vectors origin clobber shasht
      org_dot_melusina_dot_confidence
    ];
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

  fset = super.fset.overrideLispAttrs (oa: {
    systems = [ "fset" "fset/test" ];
    meta = {
      description = "functional collections library";
      homepage = "https://gitlab.common-lisp.net/fset/fset/-/wikis/home";
      license = pkgs.lib.licenses.llgpl21;
    };
  });

  thih-coalton = self.coalton;
  quil-coalton = self.coalton;
  coalton = super.coalton.overrideLispAttrs (oa: {
    systems = [
      "coalton"
      "thih-coalton"
      "quil-coalton"
      "thih-coalton/tests"
      "quil-coalton/tests"
      "coalton/tests"
    ];
    lispLibs = oa.lispLibs ++ [ self.fiasco ];
    nativeLibs = [ pkgs.mpfr ];
    meta = {
      description = "statically typed functional programming language that supercharges Common Lisp";
      homepage = "https://coalton-lang.github.io";
      license = pkgs.lib.licenses.mit;
    };
  });

  } // optionalAttrs pkgs.config.allowAliases {
    cl-glib_dot_gio = throw "cl-glib_dot_gio was replaced by cl-gio";
    cl-gtk4_dot_webkit2 = throw "cl-gtk4_dot_webkit2 was replaced by cl-gtk4_dot_webkit";
  });

in packages
