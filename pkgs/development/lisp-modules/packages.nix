{ build-asdf-system, spec, quicklispPackagesFor, pkgs, ... }:

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

  # A little hacky
  isJVM = spec.pkg.pname == "abcl";

  # Makes it so packages imported from Quicklisp can be re-used as
  # lispLibs ofpackages in this file.
  ql = quicklispPackagesFor spec;

  packages = ql.overrideScope (self: super: {

  cffi = let
    jna = pkgs.fetchMavenArtifact {
      groupId = "net.java.dev.jna";
      artifactId = "jna";
      version = "5.9.0";
      sha256 = "0qbis8acv04fi902qzak1mbagqaxcsv2zyp7b8y4shs5nj0cgz7a";
    };
  in build-asdf-system {
    src =  pkgs.fetchzip {
      url = "http://beta.quicklisp.org/archive/cffi/2021-04-11/cffi_0.24.1.tgz";
      sha256 = "17ryim4xilb1rzxydfr7595dnhqkk02lmrbkqrkvi9091shi4cj3";
    };
    version = "0.24.1";
    pname = "cffi";
    lispLibs = with super; [
      alexandria
      babel
      trivial-features
    ];
    javaLibs = optionals isJVM [ jna ];
  };

  cffi-libffi = build-asdf-system {
    inherit (super.cffi-libffi) pname version asds lispLibs nativeLibs nativeBuildInputs;
    src = pkgs.fetchzip {
      url = "https://github.com/cffi/cffi/archive/3f842b92ef808900bf20dae92c2d74232c2f6d3a.tar.gz";
      sha256 = "1jilvmbbfrmb23j07lwmkbffc6r35wnvas5s4zjc84i856ccclm2";
    };
  };

  cl-unicode = build-with-compile-into-pwd {
    pname = "cl-unicode";
    version = "0.1.6";
    src =  pkgs.fetchzip {
      url = "https://github.com/edicl/cl-unicode/archive/refs/tags/v0.1.6.tar.gz";
      sha256 = "0ykx2s9lqfl74p1px0ik3l2izd1fc9jd1b4ra68s5x34rvjy0hza";
    };
    systems = [ "cl-unicode" ];
    lispLibs = with super; [
      cl-ppcre
      flexi-streams
    ];
  };

  jzon = build-asdf-system {
    src = pkgs.fetchzip {
      url = "https://github.com/Zulu-Inuoe/jzon/archive/6b201d4208ac3f9721c461105b282c94139bed29.tar.gz";
      sha256 = "01d4a78pjb1amx5amdb966qwwk9vblysm1li94n3g26mxy5zc2k3";
    };
    version = "0.0.0-20210905-6b201d4208";
    pname = "jzon";
    lispLibs = [
      super.closer-mop
    ];
    systems = [ "com.inuoe.jzon" ];
  };

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
    lispLibs = super.cl-liballegro-nuklear.lispLibs ++ [ super.cl-liballegro ];
    patches = [ ./patches/cl-liballegro-nuklear-missing-dll.patch ];
  };

  tuple = build-asdf-system {
    pname = "tuple";
    version = "b74bd067d";
    src = pkgs.fetchzip {
      url = "https://fossil.galkowski.xyz/tuple/tarball/b74bd067d4533ac0/tuple.tar.gz";
      sha256 = "0dk356vkv6kwwcmc3j08x7143549m94rd66rpkzq8zkb31cg2va8";
    };
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
    lispLibs = [ self.lessp self.rollback ] ++ [ super.local-time ];
  };

  cl-fuse = build-with-compile-into-pwd {
    inherit (super.cl-fuse) pname version src lispLibs;
    nativeBuildInputs = [ pkgs.fuse ];
    nativeLibs = [ pkgs.fuse ];
  };

  cl-containers = build-asdf-system {
    inherit (super.cl-containers) pname version src;
    lispLibs = super.cl-containers.lispLibs ++ [ super.moptilities ];
    systems = [ "cl-containers" "cl-containers/with-moptilities" ];
  };

  swank = build-with-compile-into-pwd {
    inherit (super.swank) pname version src lispLibs;
    patches = [ ./patches/swank-pure-paths.patch ];
    postConfigure = ''
      substituteAllInPlace swank-loader.lisp
    '';
  };

  clx-truetype = build-asdf-system {
    pname = "clx-truetype";
    version = "20160825-git";
    src = pkgs.fetchzip {
      url = "http://beta.quicklisp.org/archive/clx-truetype/2016-08-25/clx-truetype-20160825-git.tgz";
      sha256 = "079hyp92cjkdfn6bhkxsrwnibiqbz4y4af6nl31lzw6nm91j5j37";
    };
    lispLibs = with super; [
      alexandria bordeaux-threads cl-aa cl-fad cl-paths cl-paths-ttf
      cl-store cl-vectors clx trivial-features zpb-ttf
    ];
  };

  mathkit = build-asdf-system {
    inherit (super.mathkit) pname version src asds ;
    lispLibs = super.mathkit.lispLibs ++ [ super.sb-cga ];
  };

  cl-colors2_0_5_4 = build-asdf-system {
    inherit (super.cl-colors2) pname systems lispLibs;
    version = "0.5.4";

    src = pkgs.fetchgit {
      url = "https://notabug.org/cage/cl-colors2";
      rev = "refs/tags/v0.5.4";
      sha256 = "sha256-JbT1BKjaXDwdlzHLPjX1eg0RMIOT86R17SPgbe2h+tA=";
    };
  };

  prompter = build-asdf-system {
    pname = "prompter";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "prompter";
      rev = "0.1.0";
      sha256 = "sha256-Duv7L2lMjr3VXsoujQDOMNHCbdUDX4RWoncVm9LDCZE=";
    };

    lispLibs = [
      self.cl-containers
      self.nclasses
      super.alexandria
      super.calispel
      super.closer-mop
      super.lparallel
      super.moptilities
      super.serapeum
      super.str
      super.trivial-package-local-nicknames
    ];

  };

  nasdf = build-asdf-system {
    pname = "nasdf";
    version = "20230911-git";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "ntemplate";
      rev = "ab7a018f3a67a999c72710644b10b4545130c139";
      sha256 = "sha256-fXGh0h6CXLoBgK1jRxkSNyQVAY1gvi4iyHQBuzueR5Y=";
    };
  };

  njson = build-asdf-system {
    pname = "njson";
    version = "1.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "njson";
      rev = "1.1.0";
      sha256 = "sha256-hVo5++QCns7Mv3zATpAP3EVz1pbj+jbQmzSLqs6hqQo=";
    };
    lispLibs = [ self.nasdf super.cl-json super.com_dot_inuoe_dot_jzon];
    systems = [ "njson" "njson/cl-json" "njson/jzon"];
  };

  nsymbols = build-asdf-system {
    pname = "nsymbols";
    version = "0.3.1";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nsymbols";
      rev = "0.3.1";
      sha256 = "sha256-KcrE06bG5Khp5/807wb/TbPG3nWTlNWHrDpmK6bm7ZM=";
    };
    lispLibs = [ super.closer-mop ];
    systems = [ "nsymbols" "nsymbols/star" ];

  };

  nclasses = build-asdf-system {
    pname = "nclasses";
    version = "0.6.0";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nclasses";
      rev = "0.6.0";
      sha256 = "sha256-JupP+TIxavUoyOPnp57FqpEjWfgKspdFoSRnV2rk5U4=";
    };
    lispLibs = [ self.nasdf super.moptilities ];
  };

  nfiles = build-asdf-system {
    pname = "nfiles";
    version = "20230705-git";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nfiles";
      rev = "3626e8d512a84efc12479ceb3969d194511757f7";
      sha256 = "sha256-MoJdbTOVfw2rJk4cf/rEnR55BxdXkoqqu9Txd/R9OYQ=";
    };
    lispLibs = [
      self.nasdf
      self.nclasses
      super.quri
      super.alexandria
      super.iolib
      super.serapeum
      super.trivial-garbage
      super.trivial-package-local-nicknames
      super.trivial-types
    ];
  };

  nhooks = build-asdf-system {
    pname = "nhooks";
    version = "1.2.1";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nhooks";
      rev = "1.2.1";
      hash = "sha256-D61QHxHTceIu5mCGKf3hy53niQMfs0idEYQK1ZYn1YM=";
    };
    lispLibs = with self; [ bordeaux-threads closer-mop serapeum ];
  };

  nkeymaps = build-asdf-system {
    pname = "nkeymaps";
    version = "20230214-git";
    src = pkgs.fetchzip {
      url = "http://beta.quicklisp.org/archive/nhooks/2023-02-14/nkeymaps-20230214-git.tgz";
      sha256 = "197vxqby87vnpgcwchs3dqihk1gimp2cx9cc201pkdzvnbrixji6";
    };
    lispLibs = with self; [ alexandria fset trivial-package-local-nicknames ];
  };


  history-tree = build-asdf-system {
    pname = "history-tree";
    version = "20230214-git";
    src = pkgs.fetchzip {
      url = "http://beta.quicklisp.org/archive/history-tree/2023-02-14/history-tree-20230214-git.tgz";
      sha256 = "12kvnc8vcvg7nmgl5iqgbr4pj0vgb8f8avk9l5czz7f2hj91ysdp";
    };
    lispLibs = with self; [
      alexandria
      cl-custom-hash-table
      local-time
      nasdf
      nclasses
      trivial-package-local-nicknames
    ];
  };

  nyxt-gtk = build-asdf-system {
    pname = "nyxt";
    version = "3.7.0";

    lispLibs = (with super; [
      alexandria
      bordeaux-threads
      calispel
      cl-base64
      cl-gopher
      cl-html-diff
      cl-json
      cl-ppcre
      cl-ppcre-unicode
      cl-prevalence
      cl-qrencode
      cl-tld
      closer-mop
      dissect
      moptilities
      dexador
      enchant
      flexi-streams
      idna
      iolib
      lass
      local-time
      lparallel
      log4cl
      montezuma
      ndebug
      osicat
      parenscript
      py-configparser
      serapeum
      str
      phos
      plump
      clss
      spinneret
      slynk
      trivia
      trivial-features
      trivial-garbage
      trivial-package-local-nicknames
      trivial-types
      unix-opts
      cluffer
      cl-cffi-gtk
      quri
      sqlite
      # TODO: Remove these overrides after quicklisp updates past the June 2023 release
      (trivial-clipboard.overrideAttrs (final: prev: {
        src = pkgs.fetchFromGitHub {
          owner = "snmsts";
          repo = "trivial-clipboard";
          rev = "6ddf8d5dff8f5c2102af7cd1a1751cbe6408377b";
          sha256 = "sha256-n15IuTkqAAh2c1OfNbZfCAQJbH//QXeH0Bl1/5OpFRM=";
        };}))
      (cl-gobject-introspection.overrideAttrs (final: prev: {
        src = pkgs.fetchFromGitHub {
          owner = "andy128k";
          repo = "cl-gobject-introspection";
          rev = "83beec4492948b52aae4d4152200de5d5c7ac3e9";
          sha256 = "sha256-g/FwWE+Rzmzm5Y+irvd1AJodbp6kPHJIFOFDPhaRlXc=";
        };}))
      (cl-webkit2.overrideAttrs (final: prev: {
        src = pkgs.fetchFromGitHub {
          owner = "joachifm";
          repo = "cl-webkit";
          rev = "66fd0700111586425c9942da1694b856fb15cf41";
          sha256 = "sha256-t/B9CvQTekEEsM/ZEp47Mn6NeZaTYFsTdRqclfX9BNg=";
        };
      }))
    ]) ++ (with self; [
      history-tree
      nhooks
      nkeymaps
      nasdf
      prompter
      cl-colors2_0_5_4
      njson
      nsymbols
      nclasses
      nfiles
      swank
      cl-containers
    ]);

    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nyxt";
      rev = "3.7.0";
      sha256 = "sha256-viiyO4fX3uyGuvojQ1rYYKBldRdVNzeJX1KYlYwfWVU=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    buildInputs = [
      # needed for GSETTINGS_SCHEMAS_PATH
      pkgs.gsettings-desktop-schemas pkgs.glib pkgs.gtk3

      # needed for XDG_ICON_DIRS
      pkgs.gnome.adwaita-icon-theme
    ];

    # This patch removes the :build-operation component from the nyxt/gi-gtk-application system.
    # This is done because if asdf:operate is used and the operation matches the system's :build-operation
    # then output translations are ignored, causing the result of the operation to be placed where
    # the .asd is located, which in this case is the nix store.
    # see: https://gitlab.common-lisp.net/asdf/asdf/-/blob/master/doc/asdf.texinfo#L2582
    patches = [ ./patches/nyxt-remove-build-operation.patch ];

    buildScript = pkgs.writeText "build-nyxt.lisp" ''
      (load "${super.alexandria.asdfFasl}/asdf.${super.alexandria.faslExt}")
      ;; There's a weird error while copy/pasting in Nyxt that manifests with sb-ext:save-lisp-and-die, so we use asdf:operare :program-op instead
      (asdf:operate :program-op :nyxt/gi-gtk-application)
    '';

    # TODO(kasper): use wrapGAppsHook
    installPhase = ''
      mkdir -pv $out
      cp -r * $out
      rm -v $out/nyxt
      mkdir -p $out/bin
      cp -v nyxt $out/bin
      wrapProgram $out/bin/nyxt \
        --prefix LD_LIBRARY_PATH : $LD_LIBRARY_PATH \
        --prefix XDG_DATA_DIRS : $XDG_ICON_DIRS \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH \
        --prefix GIO_EXTRA_MODULES ":" ${pkgs.dconf.lib}/lib/gio/modules/ \
        --prefix GIO_EXTRA_MODULES ":" ${pkgs.glib-networking}/lib/gio/modules/
    '';
  };

  nyxt = self.nyxt-gtk;

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

  ltk = super.ltk.overrideLispAttrs (o: {
    src = pkgs.fetchzip {
      url = "https://github.com/uthar/ltk/archive/f19162e76d6c7c2f51bd289b811d9ba20dd6555e.tar.gz";
      sha256 = "0mzikv4abq9yqlj6dsji1wh34mjizr5prv6mvzzj29z1485fh1bj";
    };
    version = "f19162e76";
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
    lispLibs = with super; [
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
    lispLibs = with super; [
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
    lispLibs = with super; [
      cl-gobject-introspection-wrapper
    ] ++ [ self.cl-glib self.cl-glib_dot_gio ];
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
    lispLibs = with super; [
      cl-gobject-introspection-wrapper
    ] ++ [ self.cl-gtk4 ];
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
    lispLibs = with super; [
      cl-gobject-introspection-wrapper
    ] ++ [ self.cl-gtk4 ];
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
    lispLibs = with super; [
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

  duckdb = build-asdf-system {
    pname = "duckdb";
    version = "trunk";
    src = pkgs.fetchFromGitHub {
      owner = "ak-coram";
      repo = "cl-duckdb";
      rev = "2f0df62f59fbede0addd8d72cf286f4007818a3e";
      hash = "sha256-+jeOuXtCFZwMvF0XvlRaqTNHIAAFKMx6y1pz6u8Wxug=";
    };
    systems = [ "duckdb" "duckdb/test" "duckdb/benchmark" ];
    lispLibs = with super; [
      bordeaux-threads
      cffi-libffi
      cl-ascii-table
      cl-spark
      fiveam
      local-time
      local-time-duration
      periods
      trivial-benchmark
      serapeum
      str
      uuid
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
    lispLibs = with super; [ clim mcclim mcclim-layouts ];
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
    lispLibs = with super; [
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
    lispLibs = [ super.alexandria ];
  };

  nsb-cga = super.nsb-cga.overrideLispAttrs (oa: {
    lispLibs = oa.lispLibs ++ [ self.sb-cga ];
  });

  });

in packages
