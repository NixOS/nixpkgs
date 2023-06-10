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

  packages = ql.overrideScope' (self: super: {

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

  cl-tar-file = build-asdf-system {
    pname = "cl-tar-file";
    version = "v0.2.1";
    src = pkgs.fetchzip {
      url = let
        rev = "0c10bc82f14702c97a26dc25ce075b5d3a2347d1";
      in "https://gitlab.common-lisp.net/cl-tar/cl-tar-file/-/archive/${rev}/cl-tar-file-${rev}.tar.gz";
      sha256 = "0i8j05fkgdqy4c4pqj0c68sh4s3klpx9kc5wp73qwzrl3xqd2svy";
    };
    lispLibs = with super; [
      alexandria
      babel
      trivial-gray-streams
      _40ants-doc
      salza2
      chipz
      flexi-streams
      parachute
    ];
    systems = [ "tar-file" "tar-file/test" ];
  };

  cl-tar = build-asdf-system {
    pname = "cl-tar";
    version = "v0.2.1";
    src = pkgs.fetchzip {
      url = let
        rev = "7c6e07a10c93d9e311f087b5f6328cddd481669a";
      in "https://gitlab.common-lisp.net/cl-tar/cl-tar/-/archive/${rev}/cl-tar-${rev}.tar.gz";
      sha256 = "0wp23cs3i6a89dibifiz6559la5nk58d1n17xvbxq4nrl8cqsllf";
    };
    lispLibs = with super; [
      alexandria
      babel
      local-time
      split-sequence
      _40ants-doc
      parachute
      osicat
    ] ++ [ self.cl-tar-file ];
    systems = [
      "tar"
      "tar/common-extract"
      "tar/simple-extract"
      "tar/extract"
      "tar/create"
      "tar/docs"
      "tar/test"
      "tar/create-test"
      "tar/extract-test"
      "tar/simple-extract-test"
    ];
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

  quri_7_0 = build-asdf-system {
    inherit (super.quri) pname systems lispLibs;
    version = "0.7.0";

    src = pkgs.fetchFromGitHub {
      owner = "fukamachi";
      repo = "quri";
      rev = "0.7.0";
      sha256 = "sha256-/9p67rfbkdrx5nn4kXEUAM9MzV7NYUsRcKsrP/e2MlA=";
    };
  };

  cl-colors2_0_5_3 = build-asdf-system {
    inherit (super.cl-colors2) pname systems lispLibs;
    version = "0.5.3";

    src = pkgs.fetchgit {
      url = "https://notabug.org/cage/cl-colors2";
      rev = "refs/tags/v0.5.3";
      sha256 = "sha256-anYkLJoNOVBQoXzWVBgbEusQDdud0RA8nZzedl8V93w=";
    };
  };

  cl-webkit2_3_5_8 = build-asdf-system {
    inherit (super.cl-webkit2) pname systems nativeLibs lispLibs;
    version = "3.5.8";

    src = pkgs.fetchFromGitHub {
      owner = "joachifm";
      repo = "cl-webkit";
      rev = "3.5.8";
      sha256 = "sha256-wZ/zRRJlTiOIny4BsU+wsFtxtS5YKx3WalwpCVQPFSY=";
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
      self.nclasses_0_5_0
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

  nasdf-unstable = build-asdf-system {
    inherit (super.nasdf) pname systems;
    version = "20230524-git";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "ntemplate";
      rev = "51a884f388ec526c32914093fcad6bb2434e3c14";
      sha256 = "sha256-bjQPkiHAxhjsHCnWpCGMsmQlGDJFGtQEdevnhK2k+kY=";
    };
  };

  njson_1_0_0 = build-asdf-system {
    inherit (super.njson) pname;
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "njson";
      rev = "1.0.0";
      sha256 = "sha256-zeOxkoi5cPl1sw1oEOaMsKhhs3Pb8EzzKTjvuDNj/Ko=";
    };
    lispLibs = [ self.nasdf-unstable super.cl-json ];
    systems = [ "njson" "njson/cl-json" ];
  };

  nsymbols_0_3_1 = build-asdf-system {
    inherit (super.nsymbols) pname;
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

  nclasses_0_5_0 = build-asdf-system {
    inherit (super.nclasses) pname systems;
    version = "0.5.0";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nclasses";
      rev = "0.5.0";
      sha256 = "sha256-UcavZ0fCA2hkVU/CqUZfyCqJ8gXKPpXTCP0WLUIF1Ss=";
    };
    lispLibs = [ self.nasdf-unstable super.moptilities ];
  };

  nfiles_1_1_2 = build-asdf-system {
    inherit (super.nfiles) pname systems;
    version = "1.1.2";
    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nfiles";
      rev = "1.1.2";
      sha256 = "sha256-YsVcCFrJIFL9Z4wQNAv6chiz6wB/eB8v/EUMXPLs3fw=";
    };
    lispLibs = [
      self.nasdf-unstable
      self.nclasses_0_5_0
      self.quri_7_0
      super.alexandria
      super.iolib
      super.serapeum
      super.trivial-garbage
      super.trivial-package-local-nicknames
      super.trivial-types
    ];
  };

  nyxt-gtk = build-asdf-system {
    inherit (super.nyxt) pname;
    version = "3.1.0";

    lispLibs = with super; [
      self.nasdf-unstable
      self.prompter
      self.cl-colors2_0_5_3
      self.njson_1_0_0
      self.nsymbols_0_3_1
      self.nclasses_0_5_0
      self.nfiles_1_1_2
      self.quri_7_0
      self.cl-webkit2_3_5_8
      self.swank
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
      cl-containers
      dissect
      moptilities
      dexador
      enchant
      flexi-streams
      history-tree
      idna
      iolib
      lass
      local-time
      lparallel
      log4cl
      montezuma
      ndebug
      nhooks
      nkeymaps
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
      trivial-clipboard
      trivial-features
      trivial-garbage
      trivial-package-local-nicknames
      trivial-types
      unix-opts
      cluffer
      cl-cffi-gtk
      cl-gobject-introspection
    ];

    src = pkgs.fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "nyxt";
      rev = "3.1.0";
      sha256 = "sha256-H3AlslECb/VvIC6zAGkLNTaGJ/nb97J6RXAN8sEgAgY=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    buildInputs = [
      # needed for GSETTINGS_SCHEMAS_PATH
      pkgs.gsettings-desktop-schemas pkgs.glib pkgs.gtk3

      # needed for XDG_ICON_DIRS
      pkgs.gnome.adwaita-icon-theme
    ];

    # This is needed since asdf:make tries to write in the directory of the .asd file of the system it's compiling
    postConfigure = ''
      export CL_SOURCE_REGISTRY=$CL_SOURCE_REGISTRY:$(pwd)//
    '';

    buildScript = pkgs.writeText "build-nyxt.lisp" ''
      (load "${super.nyxt.asdfFasl}/asdf.${super.nyxt.faslExt}")
      ;; There's a weird error while copy/pasting in Nyxt that manifests with sb-ext:save-lisp-and-die, so we use asdf:make instead
      (asdf:make :nyxt/gi-gtk-application)
    '';

    # TODO(kasper): use wrapGAppsHook
    installPhase = super.nyxt.installPhase + ''
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


  qt = let
    rev = "dffff3ee3dbd0686c85c323f579b8bbf4881e60e";
  in build-with-compile-into-pwd rec {
    pname = "commonqt";
    version = builtins.substring 0 7 rev;
    src = pkgs.fetchFromGitHub {
      inherit rev;
      owner = pname;
      repo = pname;
      hash = "sha256-GAgwT0D9mIkYPTHfCH/KxxIv7b6QGwcxwZE7ehH5xug=";
    };

    buildInputs = [ pkgs.qt4 ];
    nativeBuildInputs = [ pkgs.smokegen pkgs.smokeqt ];
    nativeLibs = [ pkgs.qt4 pkgs.smokegen pkgs.smokeqt ];

    systems = [ "qt" ];

    lispLibs = with super; [
      cffi named-readtables cl-ppcre alexandria
      closer-mop iterate trivial-garbage bordeaux-threads
    ];
  };

  qt-libs = build-with-compile-into-pwd {
    inherit (super.qt-libs) pname version src;
    patches = [ ./patches/qt-libs-dont-download.patch ];
    prePatch = ''
      substituteInPlace systems/*.asd --replace ":qt+libs" ":qt"
    '';
    lispLibs = super.qt-libs.lispLibs ++ [ self.qt ];
    systems = [
      "qt-libs"
      "commonqt"
      # "phonon"
      # "qimageblitz"
      # "qsci"
      "qt3support"
      "qtcore"
      "qtdbus"
      "qtdeclarative"
      "qtgui"
      "qthelp"
      "qtnetwork"
      "qtopengl"
      "qtscript"
      "qtsql"
      "qtsvg"
      "qttest"
      "qtuitools"
      # "qtwebkit"
      "qtxml"
      "qtxmlpatterns"
      # "qwt"
      "smokebase"
    ];
  };

  commonqt = self.qt-libs;
  qt3support = self.qt-libs;
  qtcore = self.qt-libs;
  qtdbus = self.qt-libs;
  qtdeclarative = self.qt-libs;
  qtgui = self.qt-libs;
  qthelp = self.qt-libs;
  qtnetwork = self.qt-libs;
  qtopengl = self.qt-libs;
  qtscript = self.qt-libs;
  qtsql = self.qt-libs;
  qtsvg = self.qt-libs;
  qttest = self.qt-libs;
  qtuitools = self.qt-libs;
  qtxml = self.qt-libs;
  qtxmlpatterns = self.qt-libs;
  smokebase = self.qt-libs;

  qtools = build-with-compile-into-pwd {
    inherit (super.qtools) pname version src nativeLibs;
    lispLibs = [ self.qt ] ++ remove super.qt_plus_libs super.qtools.lispLibs ++ [ self.qt-libs ];
    patches = [ ./patches/qtools-use-nix-libs.patch ];
  };

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

  });

in packages
