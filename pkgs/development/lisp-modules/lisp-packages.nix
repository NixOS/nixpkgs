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
    version = "git-20150117";
    description = "An implementation of the X Window System protocol in Lisp";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/sharplispers/clx'';
      sha256 = "ada6cf450c22d1ed297e5575f832bee8e4b61d602ffa9a145ae2fab7cd80f3b6";
      rev = ''0a3bea0fab66058e9394973e23954c43083d96e2'';
      name = "clx-git-checkout-${version}";
    };
  };

  iterate = buildLispPackage rec {
    baseName = "iterate";
    version = "darcs-2014-11-01";
    description = "Iteration package for Common Lisp";
    deps = [];
    src = (pkgs.lib.overrideDerivation (pkgs.fetchdarcs {
      url = "https://common-lisp.net/project/iterate/darcs/iterate";
      sha256 = "0gm05s3laiivsqgqjfj1rkz83c2c0jyn4msfgbv6sz42znjpam25";
      context = ./iterate.darcs-context;
    }) (x: {SSL_CERT_FILE=pkgs.cacert + "/etc/ssl/certs/ca-bundle.crt";}));
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
      url = "https://gitlab.common-lisp.net/alexandria/alexandria.git";
      sha256 = "1gx642w00cnnkbkcsnzmg1w147r6yvc0ayns7ha4k0qcvfnb1zvs";
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
    version = "git-2015-07-01";
    description = "";
    deps = [];
    src = pkgs.fetchgit {
      url = "https://gitlab.common-lisp.net/cl-unification/cl-unification.git";
      sha256 = "0b7yik1ma7ciwscald624325dl6265fbq52iwy6jh46nvv085dqk";
      rev = ''283c94d38d11c806a1fc9db022f0b54dced93bab'';
    };
  };

  esrap = buildLispPackage rec {
    baseName = "esrap";
    version = "git-20131029";
    description = "A Packrat / Parsing Grammar / TDPL parser for Common Lisp";
    deps = [alexandria];
    src = pkgs.fetchgit {
      url = "https://github.com/scymtym/esrap.git";
      sha256 = "175jsv309yir0yi03aa2995xg84zjgk34kgnbql5l4vy4as5x665";
      rev = ''c71933b84e220f21e8a509ec26afe3e3871e2e26'';
    };
  };

  clx-truetype = buildLispPackage rec {
    baseName = "clx-truetype";
    version = "git-20141112";
    description = "A pure Common Lisp solution for antialiased TrueType font rendering using CLX and the XRender extension";
    deps = [cl-fad cl-store cl-vectors clx trivial-features zpb-ttf];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/filonenko-mikhail/clx-truetype'';
      sha256 = "14wx9s1fd56l25ms2ns1w9a5rxgqr00vgw6jdarfkqk7mfrxxzs1";
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
    description = "Ensures consistent *FEATURES* across multiple CLs";
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
    version = "git-20150514";
    description = "Common Lisp SQL Interface library";
    deps = [uffi];
    buildInputs = [pkgs.mysql.client pkgs.zlib];
    # Source type: git
    src = pkgs.fetchgit {
      url =
        #''http://git.kpe.io/clsql.git''
	"http://repo.or.cz/r/clsql.git"
	;
      sha256 = "073rh2zxwkcd417qfcflv14j273d1j174slsbzidxvy4zgq5r3n6";
      rev = ''a646f558b54191eda1d64f2926eee7b4fa763f89'';
    };
    overrides = x:{
      preConfigure = ''
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${stdenv.lib.getDev pkgs.mysql.client}/include/mysql"
        export NIX_LDFLAGS="$NIX_LDFLAGS -L${stdenv.lib.getLib pkgs.mysql.client}/lib/mysql"
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
      url = ''http://git.kpe.io/uffi.git'';
      sha256 = "1hqszvz0a3wk4s9faa83sc3vjxcb5rxmjclyr17yzwg55z733kry";
      rev = ''a63da5b764b6fa30e32fcda4ddac88de385c9d5b'';
    };
  };

  query-fs = buildLispPackage rec {
    baseName = "query-fs";
    version = "git-20150523";
    description = "High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries";
    deps = [bordeaux-threads cl-fuse cl-fuse-meta-fs cl-ppcre command-line-arguments iterate trivial-backtrace];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/fb08af68/query-fs'';
      sha256 = "19h6hscza7p93bc7jvb6ya7ghg96dr1c1v4imlxpjqfdhhdpxsq6";
      rev = ''0f28e3f31a4cd3636a8edb346230482e68af86c2'';
    };
    overrides = x: {
      linkedSystems = [];
      postInstall = ''
        export CL_SOURCE_REGISTRY="$CL_SOURCE_REGISTRY:$out/lib/common-lisp/query-fs"
	export HOME=$PWD
	build-with-lisp.sh sbcl \
	  ":query-fs $(echo "$linkedSystems" | sed -re 's/(^| )([^ :])/ :\2/g')" \
	  "$out/bin/query-fs" \
	  "(query-fs:run-fs-with-cmdline-args)"
      '';
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
    description = "A charset conversion library";
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
    src = (pkgs.lib.overrideDerivation (pkgs.fetchdarcs {
      url = ''http://common-lisp.net/project/trivial-utf-8/darcs/trivial-utf-8/'';
      sha256 = "1jz27gz8gvqdmvp3k9bxschs6d5b3qgk94qp2bj6nv1d0jc3m1l1";
    }) (x: {SSL_CERT_FILE=pkgs.cacert + "/etc/ssl/certs/ca-bundle.crt";}));
  };

  cl-fuse-meta-fs = buildLispPackage rec {
    baseName = "cl-fuse-meta-fs";
    version = "git-20150523";
    description = "CFFI bindings to FUSE (Filesystem in user space)";
    deps = [bordeaux-threads cl-fuse iterate pcall];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/fb08af68/cl-fuse-meta-fs'';
      sha256 = "0cpxwsc0ma1ypl54n3n37wbgdxhz5j67h28q6rhghjn96dgy4ac9";
      rev = ''6ab92ebbb8e6f1f69d179214032915e3744d8c03'';
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
    description = "Small library to deal with command-line arguments";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''http://common-lisp.net/project/qitab/git/command-line-arguments.git'';
      sha256 = "1jgx8k706wz2qjdnqnralvnhwlzxd0nx22r6rncgs2kw7p4wll9d";
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
      sha256 = "0bclk05lqijpp72yfzrz0wmw142z0mwnpfl4gqv6gl4fpz1qr56s";
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
      sha256 = "0963nyg8173q0svqhk0ggbvfr4i57jk3swkf0r87jh3yi2l983sl";
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
    description = "Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams)";
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
    description = "Common Lisp interface to OpenSSL";
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
    description = "Portable finalizers, weak hash-tables and weak pointers";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/trivial-garbage/trivial-garbage'';
      sha256 = "0r029lfl5srmhanmmh7bb692pdwb32cnbq2navx6cm3iqda9q87i";
      rev = ''2721d36d71748d9736a82fe5afe333c52bae3084'';
    };
  };

  cl-base64 = buildLispPackage rec {
    baseName = "cl-base64";
    version = "git-20141113";
    description = "Base64 encoding and decoding with URI support";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''http://git.kpe.io/cl-base64.git'';
      sha256 = "0cq3dxac3l0z2xp3c3gkgj893hvaz4vvxdz0nsc8c9q28q3nwf4p";
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
      url = ''http://git.kpe.io/puri.git'';
      sha256 = "1l7d8i9615kyi7n69l07a6ri0d1k13cya0kbg3fmfqanwn5kzv2i";
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
      sha256 = "0s8jjn3s55m59nihc8qiw2s71gn09sxsaii343rzfwdrkdwk9vzh";
      rev = ''b21e8757210a1eb2a47104a563f58bf82ba9a579'';
    };
  };

  nibbles = buildLispPackage rec {
    baseName = "nibbles";
    version = "git-20141116";
    description = "A library for accessing octet-addressed blocks of data";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/froydnj/nibbles'';
      sha256 = "0p0swss7xjx74sr95wqak5hfhfw13bwkzncy4l4hbfy130gncv8b";
      rev = ''ace095d85e48b18bf9cf9e21249ba7fb57e3efe2'';
    };
  };

  ironclad = buildLispPackage rec {
    baseName = "ironclad";
    version = "0.33.0";
    description = "A cryptographic toolkit written in pure Common Lisp";
    deps = [nibbles];
    # Source type: http
    src = pkgs.fetchurl {
      url = ''http://method-combination.net/lisp/files/ironclad_0.33.0.tar.gz'';
      sha256 = "1ld0xz8gmi566zxl1cva5yi86aw1wb6i6446gxxdw1lisxx3xwz7";
    };
  };

  cl-smtp = buildLispPackage rec {
    baseName = "cl-smtp";
    version = "git-2015-07-01";
    description = "SMTP client library";
    deps = [cl-ssl cl-base64 flexi-streams trivial-gray-streams usocket];
    # Source type: git
    src = pkgs.fetchgit {
      url = "https://gitlab.common-lisp.net/cl-smtp/cl-smtp.git";
      sha256 = "0kvb34jzb3hgvzqlwwwmnyaqj0ghlgmi1x2zll5qw5089gbhfv10";
      rev = ''2bf946c1d561c0085dba6d6337e3e53d9711a5d2'';
    };
  };

  md5 = buildLispPackage rec {
    baseName = "md5";
    version = "git-20150415";
    description = "The MD5 Message-Digest Algorithm RFC 1321";
    deps = [];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/pmai/md5'';
      sha256 = "18k6k04cqx9zx0q8x3hk5icvjhihra1za7k2jx82xb19jfnjli1y";
      rev = ''9d6f82f7121c87fb7e3b314987ba93900d300dc6'';
    };
  };

  clx-xkeyboard = buildLispPackage rec {
    baseName = "clx-xkeyboard";
    version = "git-20150523";
    description = "CLX support for X Keyboard extensions";
    deps = [clx];
    # Source type: git
    src = pkgs.fetchgit {
      url = ''https://github.com/filonenko-mikhail/clx-xkeyboard'';
      sha256 = "11b34da7d354a709a24774032e85a8947be023594f8a333eaff6d4aa79f2b3db";
      rev = ''11455d36283ef31c498bd58ffebf48c0f6b86ea6'';
    };
  };

  quicklisp = buildLispPackage rec {
    baseName = "quicklisp";
    version = "2016-01-21";
    description = "The Common Lisp package manager";
    deps = [];
    src = pkgs.fetchgit {
      url = "https://github.com/quicklisp/quicklisp-client/";
      rev = "refs/tags/version-${version}";
      sha256 = "007r1ydbhrkh6ywqgpvzp0xg0yypgrfai3n4mn16gj5w2zz013lx";
    };
    overrides = x: rec {
      inherit clwrapper;
      quicklispdist = pkgs.fetchurl {
        # Will usually be replaced with a fresh version anyway, but needs to be
        # a valid distinfo.txt
        url = "http://beta.quicklisp.org/dist/quicklisp/2016-03-18/distinfo.txt";
        sha256 = "13mvign4rsicfvg3vs3vj1qcjvj2m1aqhq93ck0sgizxfcj5167m";
      };
      buildPhase = '' true; '';
      postInstall = ''
        substituteAll ${./quicklisp.sh} "$out"/bin/quicklisp
        chmod a+x "$out"/bin/quicklisp
        cp "${quicklispdist}" "$out/lib/common-lisp/quicklisp/quicklisp-distinfo.txt"
      '';
    };
  };

};
in lispPackages
