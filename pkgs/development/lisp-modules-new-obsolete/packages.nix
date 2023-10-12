{ build-asdf-system, lisp, quicklispPackagesFor, fixupFor, pkgs, ... }:

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
            export LD_LIBRARY_PATH=${makeLibraryPath o.nativeLibs}:$LD_LIBRARY_PATH
            export CLASSPATH=${makeSearchPath "share/java/*" o.javaLibs}:$CLASSPATH
            export CL_SOURCE_REGISTRY=$CL_SOURCE_REGISTRY:$(pwd)//
            export ASDF_OUTPUT_TRANSLATIONS="$(pwd):$(pwd)/__fasls:${storeDir}:${storeDir}"
            ${o.lisp} ${o.buildScript}
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
  isJVM = hasSuffix "abcl" (head (splitString " " lisp));

  # Makes it so packages imported from Quicklisp can be re-used as
  # lispLibs ofpackages in this file.
  ql = quicklispPackagesFor { inherit lisp; fixup = fixupFor packages; };

  packages = rec {

  asdf = build-with-compile-into-pwd {
    pname = "asdf";
    version = "3.3.5.3";
    src = pkgs.fetchzip {
      url = "https://gitlab.common-lisp.net/asdf/asdf/-/archive/3.3.5.3/asdf-3.3.5.3.tar.gz";
      sha256 = "0aw200awhg58smmbdmz80bayzmbm1a6547gv0wmc8yv89gjqldbv";
    };
    systems = [ "asdf" "uiop" ];
  };

  uiop = asdf.overrideLispAttrs(o: {
    pname = "uiop";
  });

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
    lispLibs = with ql; [
      alexandria
      babel
      trivial-features
    ];
    javaLibs = optionals isJVM [ jna ];
  };

  cffi-libffi = ql.cffi-libffi.overrideLispAttrs (o: {
    src = pkgs.fetchzip {
      url = "https://github.com/cffi/cffi/archive/3f842b92ef808900bf20dae92c2d74232c2f6d3a.tar.gz";
      sha256 = "1jilvmbbfrmb23j07lwmkbffc6r35wnvas5s4zjc84i856ccclm2";
    };
    patches = [ ./patches/cffi-libffi-darwin-ffi-h.patch ];
  });

  cl-unicode = build-with-compile-into-pwd {
    pname = "cl-unicode";
    version = "0.1.6";
    src =  pkgs.fetchzip {
      url = "https://github.com/edicl/cl-unicode/archive/refs/tags/v0.1.6.tar.gz";
      sha256 = "0ykx2s9lqfl74p1px0ik3l2izd1fc9jd1b4ra68s5x34rvjy0hza";
    };
    systems = [ "cl-unicode" ];
    lispLibs = with ql; [
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
      ql.closer-mop
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
      cffi
    ];
    nativeLibs = [
      pkgs.libnotify
    ];
  };

  cl-liballegro-nuklear = build-with-compile-into-pwd {
    inherit (ql.cl-liballegro-nuklear) pname version src;
    nativeBuildInputs = [ pkgs.allegro5 ];
    nativeLibs = [ pkgs.allegro5 ];
    lispLibs = ql.cl-liballegro-nuklear.lispLibs ++ [ ql.cl-liballegro ];
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
    lispLibs = with ql; [
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
    lispLibs = with ql; [
      alexandria
      babel
      local-time
      split-sequence
      _40ants-doc
      parachute
      osicat
    ] ++ [ cl-tar-file ];
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
      url = "https://github.com/facts-db/cl-lessp/archive/632217602b85b679e8d420654a0aa39e798ca3b5.tar.gz";
      sha256 = "09z1vwzjm7hlb529jl3hcjnfd11gh128lmdg51im7ar4jv4746iw";
    };
    lispLibs = [ lessp rollback ] ++ [ ql.local-time ];
  };


  cl-fuse = build-with-compile-into-pwd {
    inherit (ql.cl-fuse) pname version src lispLibs;
    nativeBuildInputs = [ pkgs.fuse ];
    nativeLibs = [ pkgs.fuse ];
  };

  cl-containers = build-asdf-system {
    inherit (ql.cl-containers) pname version src;
    lispLibs = ql.cl-containers.lispLibs ++ [ ql.moptilities ];
    systems = [ "cl-containers" "cl-containers/with-moptilities" ];
  };

  swank = build-with-compile-into-pwd {
    inherit (ql.swank) pname version src lispLibs;
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
    lispLibs = with ql; [
      alexandria bordeaux-threads cl-aa cl-fad cl-paths cl-paths-ttf
      cl-store cl-vectors clx trivial-features zpb-ttf
    ];
  };

  mathkit = build-asdf-system {
    inherit (ql.mathkit) pname version src asds lisp;
    lispLibs = ql.mathkit.lispLibs ++ [ ql.sb-cga ];
  };

  nyxt-gtk = build-asdf-system {
    inherit (ql.nyxt) pname lisp;
    version = "2.2.4";

    lispLibs = ql.nyxt.lispLibs ++ (with ql; [
      cl-cffi-gtk cl-webkit2 mk-string-metrics
    ]);

    src = pkgs.fetchzip {
      url = "https://github.com/atlas-engineer/nyxt/archive/2.2.4.tar.gz";
      sha256 = "12l7ir3q29v06jx0zng5cvlbmap7p709ka3ik6x29lw334qshm9b";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildInputs = [
      # needed for GSETTINGS_SCHEMAS_PATH
      pkgs.gsettings-desktop-schemas pkgs.glib pkgs.gtk3

      # needed for XDG_ICON_DIRS
      pkgs.gnome.adwaita-icon-theme
    ];

    buildScript = pkgs.writeText "build-nyxt.lisp" ''
      (require :asdf)
      (asdf:load-system :nyxt/gtk-application)
      (sb-ext:save-lisp-and-die "nyxt" :executable t
                                       #+sb-core-compression :compression
                                       #+sb-core-compression t
                                       :toplevel #'nyxt:entry-point)
    '';

    # Run with WEBKIT_FORCE_SANDBOX=0 if getting a runtime error in webkitgtk-2.34.4
    installPhase = ql.nyxt.installPhase + ''
      rm -v $out/nyxt
      mkdir -p $out/bin
      cp -v nyxt $out/bin
      wrapProgram $out/bin/nyxt \
        --prefix LD_LIBRARY_PATH : $LD_LIBRARY_PATH \
        --prefix XDG_DATA_DIRS : $XDG_ICON_DIRS \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix GIO_EXTRA_MODULES ":" ${pkgs.dconf.lib}/lib/gio/modules/ \
        --prefix GIO_EXTRA_MODULES ":" ${pkgs.glib-networking}/lib/gio/modules/
    '';
  };

  nyxt = nyxt-gtk;

  ltk = ql.ltk.overrideLispAttrs (o: {
    src = pkgs.fetchzip {
      url = "https://github.com/uthar/ltk/archive/f19162e76d6c7c2f51bd289b811d9ba20dd6555e.tar.gz";
      sha256 = "0mzikv4abq9yqlj6dsji1wh34mjizr5prv6mvzzj29z1485fh1bj";
    };
    version = "f19162e76";
  });
  };
in packages
