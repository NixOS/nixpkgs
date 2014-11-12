{stdenv, clwrapper, pkgs}:
let lispPackages = rec {
  inherit pkgs clwrapper stdenv;
  nixLib = pkgs.lib;
  callPackage = nixLib.callPackageWith lispPackages;

  buildLispPackage =  callPackage ./define-package.nix;

  cl-ppcre = buildLispPackage rec {
    baseName = "cl-ppcre";
    version = "2.0.4";
    description = "Regular expression library for Common Lisp";
    deps = [];
    src = pkgs.fetchurl {
      url = "https://github.com/edicl/cl-ppcre/archive/v${version}.tar.gz";
      sha256 = "16nkfg6j7nn8qkzxn462kqpdlbajpz2p55pdl12sia6yqkj3lh97";
    };
  };

  clx = buildLispPackage rec {
    baseName = "clx";
    version = "2014-11-03";
    description = "X11 bindings for Common Lisp";
    deps = [];
    src = pkgs.fetchgit {
      url = "https://github.com/sharplispers/clx.git";
      rev = "c2910c5d707a97e87b354de3f2fbe2ae038e9bc8";
      sha256 = "1jk0hfk6rb9cf58xhqq7vaisj63k3x9jpj06wqpa32y5ppjcyijw";
      name = "clx-git-checkout-${version}";
    };
  };

  iterate = buildLispPackage rec {
    baseName = "iterate";
    version = "1.4.3";
    description = "Iteration package for Common Lisp";
    deps = [];
    src = pkgs.fetchdarcs {
      url = "http://common-lisp.net/project/iterate/darcs/iterate";
      sha256 = "0m3q0s7h5s8varwx584m2akgdslj14df7kg4w1bj1fbgzsag5m1w";
      rev = version;
    };
    overrides = x: {
      configurePhase="buildPhase(){ true; }";
    };
  };

  alexandria = buildLispPackage rec {
    baseName = "alexandria";
    version = "git-20131029";
    description = "A collection of portable public domain utilities";
    deps = [];
    src = pkgs.fetchgit {
      url = "git://common-lisp.net/projects/alexandria/alexandria.git";
      sha256 = "1d981a243f9d4d3c9fd86cc47698050507ff615b87b9a710449abdb4234e501b";
      rev = ''2b1eb4067fb34bc501e527de75d09166a8ba9ceb'';
    };
  };

  esrap-peg = buildLispPackage rec {
    baseName = "esrap-peg";
    version = "git-20131029";
    description = "A wrapper around Esrap to allow generating Esrap grammars from PEG definitions";
    deps = [alexandria cl-unification esrap iterate];
    src = pkgs.fetchgit {
      url = "https://github.com/fb08af68/esrap-peg.git";
      sha256 = "48e616a697aca95e90e55052fdc9a7f96bf29b3208b1b4012fcd3189c2eceeb1";
      rev = ''1f2f21e32e618f71ed664cdc5e7005f8b6b0f7c8'';
    };
  };

  cl-unification = buildLispPackage rec {
    baseName = "cl-unification";
    version = "cvs-2013-10-28";
    description = "";
    deps = [];
    src = pkgs.fetchcvs {
      sha256 = "a574b7f9615232366e3e5e7ee400d60dbff23f6d0e1def5a3c77aafdfd786e6a";
      date = ''2013-10-28'';
      module = ''cl-unification'';
      cvsRoot = '':pserver:anonymous:anonymous@common-lisp.net:/project/cl-unification/cvsroot'';
    };
  };

  esrap = buildLispPackage rec {
    baseName = "esrap";
    version = "git-20131029";
    description = "A Packrat / Parsing Grammar / TDPL parser for Common Lisp";
    deps = [alexandria];
    src = pkgs.fetchgit {
      url = "https://github.com/scymtym/esrap.git";
      sha256 = "c56616ac01be0f69e72902f9fd830a8af2c2fa9018b66747a5da3988ae38817f";
      rev = ''c71933b84e220f21e8a509ec26afe3e3871e2e26'';
    };
  };

  clx-truetype = buildLispPackage rec {
    baseName = "clx-truetype";
    version = "git-20141112";
    description = "clx-truetype is pure common lisp solution for antialiased TrueType font rendering using CLX and XRender extension.";
    deps = [cl-fad cl-store cl-vectors clx trivial-features zpb-ttf];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/filonenko-mikhail/clx-truetype'';
      sha256 = "fe3d3923909a8f0a19298bfa366bb265c5155eed43d4dd315920535d15424d65";
      rev = ''6f72905c6886a656e5a1c8167097f12375c6da7d'';
    };
    overrides = x:{
      configurePhase = "rm Makefile";
    };
  };

  cl-fad = buildLispPackage rec {
    baseName = "cl-fad";
    version = "v0.7.2";
    description = "Portable pathname library";
    deps = [alexandria bordeaux-threads];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/edicl/cl-fad'';
      sha256 = "87917ab4af4f713ad41faa72c7eaed2872f8dac47f49c0668ba8782590fdbca4";
      rev = ''refs/tags/v0.7.2'';
    };
  };

  bordeaux-threads = buildLispPackage rec {
    baseName = "bordeaux-threads";
    version = "0.8.3";
    description = "Bordeaux Threads makes writing portable multi-threaded apps simple";
    deps = [alexandria];
    # Source type: http
    src = pkgs.fetchurl {
      url = ''http://common-lisp.net/project/bordeaux-threads/releases/bordeaux-threads-0.8.3.tar.gz'';
      sha256 = "0c3n7qsx4jc3lg8s0n9kxfvhhyl0s7123f3038nsb96rf0bvb5hy";
    };
  };

  zpb-ttf = buildLispPackage rec {
    baseName = "zpb-ttf";
    version = "release-1.0.3";
    description = "Access TrueType font metrics and outlines from Common Lisp";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/xach/zpb-ttf'';
      sha256 = "3092a3ba9f27b091224d11c0ccfb09c9a4632ebfd6c3986df3147f19e53606f2";
      rev = ''refs/tags/release-1.0.3'';
    };
  };

  cl-store = buildLispPackage rec {
    baseName = "cl-store";
    version = "git-20141112";
    description = "Serialization package";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/skypher/cl-store'';
      sha256 = "7096ad38d5c77d58f7aa0ef8df1884411173c140408cb7967922b315ab505472";
      rev = ''2d2455c024fe64ee24cbf914c82254fa5bd09cab'';
    };
  };

  cl-vectors = buildLispPackage rec {
    baseName = "cl-vectors";
    version = "git-20141112";
    description = "cl-paths: vectorial paths manipulation";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/fjolliton/cl-vectors'';
      sha256 = "2d1428911cd2699513a0b886661e9b54d1edf78558277ac83723a22c7fc9dea7";
      rev = ''7b3e5d6a8abe3de307c1dc0c4347f4efa4f25f29'';
    };
  };

  trivial-features = buildLispPackage rec {
    baseName = "trivial-features";
    version = "git-20141112";
    description = "Ensures consistent *FEATURES* across multiple CLs.";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/trivial-features/trivial-features'';
      sha256 = "2006aebe0c2bfed1c39a2195639e221fdc52a443b6c8522e535cbef2370a07fc";
      rev = ''2b7cdc3b8073eb33655850b51223770b535da6d9'';
    };
  };

  clsql = buildLispPackage rec {
    baseName = "clsql";
    version = "git-20141112";
    description = "Common Lisp SQL Interface library";
    deps = [uffi];
    buildInputs = [pkgs.mysql pkgs.zlib];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''http://git.b9.com/clsql.git'';
      sha256 = "dacd56bc9a0348e8101184bf154b971407a98f3a753d7cce34c7a44b4b19f8fd";
      rev = ''180b52cb686a87487e12e87b13bafe131e6c3bef'';
    };
    overrides = x:{
      preConfigure = ''
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pkgs.mysql}/include/mysql"
	export NIX_LDFLAGS="$NIX_LDFLAGS -L${pkgs.mysql}/lib/mysql"
      '';
    };
  };

  uffi = buildLispPackage rec {
    baseName = "uffi";
    version = "git-20141112";
    description = "Universal Foreign Function Library for Common Lisp";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''http://git.b9.com/uffi.git'';
      sha256 = "219e4cfebfac251c922bcb9d517980b0988d765bd18b7f5cc765a43913aaacc6";
      rev = ''a63da5b764b6fa30e32fcda4ddac88de385c9d5b'';
    };
  };
};
in lispPackages
