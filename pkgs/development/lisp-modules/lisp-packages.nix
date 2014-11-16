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
    version = "darcs-2014-11-01";
    description = "Iteration package for Common Lisp";
    deps = [];
    src = pkgs.fetchdarcs {
      url = "http://common-lisp.net/project/iterate/darcs/iterate";
      sha256 = "0gm05s3laiivsqgqjfj1rkz83c2c0jyn4msfgbv6sz42znjpam25";
      context = ./iterate.darcs-context;
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

  query-fs = buildLispPackage rec {
    baseName = "query-fs";
    version = "git-20141113";
    description = "High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries";
    deps = [bordeaux-threads cl-fuse cl-fuse-meta-fs cl-ppcre command-line-arguments iterate trivial-backtrace];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/fb08af68/query-fs'';
      sha256 = "4ed66f255e50d2c9ea9f0b3fbaa92bde9b8acf6a5fafb0d7f12b254be9de99e9";
      rev = ''831f0180967f09b1dd345fef82144f48334279c3'';
    };
  };

  cl-fuse = buildLispPackage rec {
    baseName = "cl-fuse";
    version = "git-20141113";
    description = "CFFI bindings to FUSE (Filesystem in user space)";
    deps = [bordeaux-threads cffi cl-utilities iterate trivial-backtrace trivial-utf-8];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/fb08af68/cl-fuse'';
      sha256 = "1l4ydxbwzlj6gkb1c9vc96rfbj951snaidpx10pxz4wdnzg3kq99";
      rev = ''6feffaa34a21cfc7890b25357284858f924e8cb3'';
    };
    propagatedBuildInputs = [pkgs.fuse];
    overrides = x : {
      configurePhase = ''
        export CL_SOURCE_REGISTRY="$CL_SOURCE_REGISTRY:$PWD"
	export makeFlags="$makeFlags LISP=common-lisp.sh"
      '';
    };
  };

  cffi = buildLispPackage rec {
    baseName = "cffi";
    version = "0.14.0";
    description = "The Common Foreign Function Interface";
    deps = [alexandria babel trivial-features];
    # Source type: http
    src = pkgs.fetchurl {
      url = ''http://common-lisp.net/project/cffi/releases/cffi_${version}.tar.gz'';
      sha256 = "155igjh096vrp7n71c0xcg9qbcpj6547qjvzi9shxbpi6piw6fkw";
    };
  };

  babel = buildLispPackage rec {
    baseName = "babel";
    version = "git-20141113";
    description = "Babel, a charset conversion library.";
    deps = [alexandria trivial-features];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/cl-babel/babel'';
      sha256 = "abe7150f25ceb7eded520d95f1665a46f4233cf13b577fd02c3f6be54c32facc";
      rev = ''74b35ea79b769c4f9aefad933923778ffa7915ab'';
    };
  };

  cl-utilities = buildLispPackage rec {
    baseName = "cl-utilities";
    version = "1.2.4";
    description = "A collection of Common Lisp utility functions";
    deps = [];
    # Source type: http
    src = pkgs.fetchurl {
      url = ''http://common-lisp.net/project/cl-utilities/cl-utilities-${version}.tar.gz'';
      sha256 = "1z2ippnv2wgyxpz15zpif7j7sp1r20fkjhm4n6am2fyp6a3k3a87";
    };
  };

  trivial-utf-8 = buildLispPackage rec {
    baseName = "trivial-utf-8";
    version = "2011-09-08";
    description = "A UTF-8 encoding library";
    deps = [];
    # Source type: darcs
    src = pkgs.fetchdarcs {
      url = ''http://common-lisp.net/project/trivial-utf-8/darcs/trivial-utf-8/'';
      sha256 = "1jz27gz8gvqdmvp3k9bxschs6d5b3qgk94qp2bj6nv1d0jc3m1l1";
    };
  };

  cl-fuse-meta-fs = buildLispPackage rec {
    baseName = "cl-fuse-meta-fs";
    version = "git-20141113";
    description = "CFFI bindings to FUSE (Filesystem in user space)";
    deps = [bordeaux-threads cl-fuse iterate pcall];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/fb08af68/cl-fuse-meta-fs'';
      sha256 = "259303effea61baf293ffc5d080cb071ef15bed8fa1c76f0c1631f68d2aa3c85";
      rev = ''d3d332471ce9330e3eaebf9d6cecdd2014c3599b'';
    };
  };

  pcall = buildLispPackage rec {
    baseName = "pcall";
    version = "0.3";
    description = "Common Lisp library intended to simplify 'result-oriented' parallelism";
    deps = [bordeaux-threads];
    # Source type: http
    src = pkgs.fetchgit {
      url = ''https://github.com/marijnh/pcall'';
      sha256 = "00ix5d9ljymrrpwsri0hhh3d592jqr2lvgbvkhav3k96rwq974ps";
      rev = "4e1ef32c33c2ca18fd8ab9afb4fa793c179a3578";
    };
  };

  command-line-arguments = buildLispPackage rec {
    baseName = "command-line-arguments";
    version = "git-20141113";
    description = "small library to deal with command-line arguments";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''http://common-lisp.net/project/qitab/git/command-line-arguments.git'';
      sha256 = "91bb321e201034c35121860cb6ec05e39c6392d5906a52b9a2d33d0f76b06123";
      rev = ''121f303bbef9c9cdf37a7a12d8adb1ad4be5a6ae'';
    };
  };

  trivial-backtrace = buildLispPackage rec {
    baseName = "trivial-backtrace";
    version = "git-2014-11-01";
    description = "trivial-backtrace";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''http://common-lisp.net/project/trivial-backtrace/trivial-backtrace.git'';
      sha256 = "1ql80z0igsng32rbp24h81pj5c4l87c1ana6c9lx3dlqpixzl4kj";
      rev = ''48a6b081e00b0d85f1e001c7258393ed34d06bc9'';
    };
  };

  drakma = buildLispPackage rec {
    baseName = "drakma";
    version = "v1.3.10";
    description = "Full-featured http/https client based on usocket";
    deps = [chipz chunga cl-ssl cl-base64 cl-ppcre flexi-streams puri usocket];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/edicl/drakma'';
      sha256 = "0ecc37c9d5cc91a3b86746c4f20c0b1609969db01041df04ff6a9df1d021b30a";
      rev = ''refs/tags/v1.3.10'';
    };
  };

  chipz = buildLispPackage rec {
    baseName = "chipz";
    version = "git-20141113";
    description = "A library for decompressing deflate, zlib, and gzip data";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/froydnj/chipz'';
      sha256 = "73ae22d58b6db5b2c86af4a465260e48a5aca19827d2b7329e2870c1148da8e2";
      rev = ''3402c94df1d0af7742df08d3ffa23fd5c04c9bf2'';
    };
  };

  chunga = buildLispPackage rec {
    baseName = "chunga";
    version = "v1.1.5";
    description = "Portable chunked streams";
    deps = [trivial-gray-streams];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/edicl/chunga'';
      sha256 = "5d045882be34b158185c491da85cfd4671f456435c9ff8fa311a864f633b0446";
      rev = ''refs/tags/v1.1.5'';
    };
  };

  trivial-gray-streams = buildLispPackage rec {
    baseName = "trivial-gray-streams";
    version = "git-20141113";
    description = "Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/trivial-gray-streams/trivial-gray-streams'';
      sha256 = "8d5c041f95eb31aa313adc433edf91bb14656400cae1e0ec98ad7ed085bb7954";
      rev = ''0483ade330508b4b2edeabdb47d16ec9437ee1cb'';
    };
  };

  cl-ssl = buildLispPackage rec {
    baseName = "cl+ssl";
    version = "git-20141113";
    description = "Common Lisp interface to OpenSSL.";
    deps = [bordeaux-threads cffi flexi-streams trivial-garbage trivial-gray-streams];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/cl-plus-ssl/cl-plus-ssl'';
      sha256 = "6b99fc49ac38e49ee69a47ce5791606b8b811c01e5563bfd3164d393db6c4040";
      rev = ''f8695c5df48ebc3557f76a8a08dd96429bdf8df2'';
    };
    propagatedBuildInputs = [pkgs.openssl];
  };

  flexi-streams = buildLispPackage rec {
    baseName = "flexi-streams";
    version = "v1.0.13";
    description = "Flexible bivalent streams for Common Lisp";
    deps = [trivial-gray-streams];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/edicl/flexi-streams'';
      sha256 = "46d6b056cffc9ea201dedde847b071db744dfbadf0a21a261717272fe3d85cab";
      rev = ''refs/tags/v1.0.13'';
    };
  };

  trivial-garbage = buildLispPackage rec {
    baseName = "trivial-garbage";
    version = "git-20141113";
    description = "Portable finalizers, weak hash-tables and weak pointers.";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/trivial-garbage/trivial-garbage'';
      sha256 = "69f6c910921de436393ff5f93bee36443534756965fa34e43e04d9e8919212df";
      rev = ''2721d36d71748d9736a82fe5afe333c52bae3084'';
    };
  };

  cl-base64 = buildLispPackage rec {
    baseName = "cl-base64";
    version = "git-20141113";
    description = "Base64 encoding and decoding with URI support.";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''http://git.b9.com/cl-base64.git'';
      sha256 = "a34196544cc67d54aef74e31eff2cee62a7861a5675d010fcd925f1c61c23e81";
      rev = ''f375d1fc3a6616e95ae88bb33493bb99f920ba13'';
    };
  };

  puri = buildLispPackage rec {
    baseName = "puri";
    version = "git-20141113";
    description = "Portable Universal Resource Indentifier Library";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''http://git.b9.com/puri.git'';
      sha256 = "71804698e7f3009fb7f570656af5d952465bfe77f72e9c41f7e2dda8a5b45c5e";
      rev = ''68260dbf320c01089c8cee54ef32c800eefcde7f'';
    };
  };

  usocket = buildLispPackage rec {
    baseName = "usocket";
    version = "0.6.1";
    description = "Universal socket library for Common Lisp";
    deps = [];
    # Source type: http
    src = pkgs.fetchurl {
      url = ''http://common-lisp.net/project/usocket/releases/usocket-${version}.tar.gz'';
      sha256 = "1lnhjli85w20iy5nn6j6gsyxx42mvj8l0dfhwcjpl6dl2lz80r7a";
    };
  };

  cl-html-parse = buildLispPackage rec {
    baseName = "cl-html-parse";
    version = "git-20141113";
    description = "HTML Parser";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/gwkkwg/cl-html-parse'';
      sha256 = "0153d4962493f106849fc7cbfe03c5ff874adae8d307ea2e1ceebbb009e2f89f";
      rev = ''b21e8757210a1eb2a47104a563f58bf82ba9a579'';
    };
  };
};
in lispPackages
