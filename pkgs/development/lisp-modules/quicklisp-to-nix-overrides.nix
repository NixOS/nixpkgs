{pkgs, buildLispPackage, clwrapper, quicklisp-to-nix-packages}:
let
  addDeps = newdeps: x: {deps = x.deps ++ newdeps;};
  addNativeLibs = libs: x: { propagatedBuildInputs = libs; };
  skipBuildPhase = x: {
    overrides = y: ((x.overrides y) // { buildPhase = "true"; });
  };
  qlnp = quicklisp-to-nix-packages;
  multiOverride = l: x: if l == [] then {} else
    ((builtins.head l) x) // (multiOverride (builtins.tail l) x);
in
{
  stumpwm = x:{
    overrides = y: (x.overrides y) // {
      preConfigure = ''
        export configureFlags="$configureFlags --with-$NIX_LISP=common-lisp.sh";
      '';
    };
    propagatedBuildInputs = (x.propagatedBuildInputs or []) ++ (with qlnp; [
      alexandria cl-ppcre clx
    ]);
  };
  iterate = skipBuildPhase;
  cl-fuse = x: {
    propagatedBuildInputs = [pkgs.fuse];
    overrides = y : (x.overrides y) // {
      configurePhase = ''
        export SAVED_CL_SOURCE_REGISTRY="$CL_SOURCE_REGISTRY"
        export CL_SOURCE_REGISTRY="$CL_SOURCE_REGISTRY:$PWD"
        export makeFlags="$makeFlags LISP=common-lisp.sh"
      '';
      preInstall = ''
        export CL_SOURCE_REGISTRY="$SAVED_CL_SOURCE_REGISTRY"
      '';
    };
  };
  hunchentoot = addNativeLibs [pkgs.openssl];
  iolib = x: rec {
    propagatedBuildInputs = (x.propagatedBuildInputs or [])
     ++ (with pkgs; [libfixposix gcc])
     ++ (with qlnp; [
       alexandria split-sequence cffi bordeaux-threads idna swap-bytes
     ])
     ;
    testSystems = ["iolib" "iolib/syscalls" "iolib/multiplex" "iolib/streams"
      "iolib/zstreams" "iolib/sockets" "iolib/trivial-sockets"
      "iolib/pathnames" "iolib/os"];

    version = "0.8.3";
    src = pkgs.fetchFromGitHub {
      owner = "sionescu";
      repo = "iolib";
      rev = "v${version}";
      sha256 = "0pa86bf3jrysnmhasbc0lm6cid9xzril4jsg02g3gziav1xw5x2m";
    };
  };
  cl-unicode = addDeps (with qlnp; [cl-ppcre flexi-streams]);
  clack =  addDeps (with qlnp;[lack bordeaux-threads prove]);
  clack-v1-compat =  addDeps (with qlnp;[
    lack bordeaux-threads prove usocket dexador http-body trivial-backtrace
    marshal local-time cl-base64 cl-ppcre quri trivial-mimes trivial-types
    flexi-streams circular-streams ironclad cl-syntax-annot alexandria
    split-sequence
  ]);
  lack = addDeps (with qlnp; [ironclad]);
  cxml = multiOverride [ skipBuildPhase (addDeps (with qlnp; [
    closure-common puri trivial-gray-streams
  ]))];
  wookie = multiOverride [(addDeps (with qlnp; [
      alexandria blackbird cl-async chunga fast-http quri babel cl-ppcre
      cl-fad fast-io vom do-urlencode cl-async-ssl
    ]))
    (addNativeLibs (with pkgs; [libuv openssl]))];
  woo = addDeps (with qlnp; [
    cffi lev clack swap-bytes static-vectors fast-http proc-parse quri fast-io
    trivial-utf-8 vom
  ]);
  lev = addNativeLibs [pkgs.libev];
  dexador = addDeps (with qlnp; [
    usocket fast-http quri fast-io chunga cl-ppcre cl-cookie trivial-mimes
    chipz cl-base64 cl-reexport qlnp."cl+ssl" alexandria bordeaux-threads
  ]);
  fast-http = addDeps (with qlnp; [
    alexandria cl-utilities proc-parse xsubseq smart-buffer
  ]);
  cl-emb = addDeps (with qlnp; [cl-ppcre]);
  "cl+ssl" = addNativeLibs [pkgs.openssl];
  cl-colors = skipBuildPhase;
  cl-libuv = addNativeLibs [pkgs.libuv];
  cl-async = addDeps (with qlnp; [cl-async-base]);
  cl-async-ssl = multiOverride [(addDeps (with qlnp; [cl-async-base]))
    (addNativeLibs [pkgs.openssl])];
  cl-async-repl = addDeps (with qlnp; [cl-async]);
  cl-async-base = addDeps (with qlnp; [
    cffi fast-io vom cl-libuv cl-ppcre trivial-features static-vectors
    trivial-gray-streams babel
  ]);
  cl-async-util = addDeps (with qlnp; [ cl-async-base ]);
  css-lite = addDeps (with qlnp; [parenscript]);
  clsql = x: {
    propagatedBuildInputs = with pkgs; [mysql postgresql sqlite zlib];
    overrides = y: (x.overrides y) // {
      preConfigure = ((x.overrides y).preConfigure or "") + ''
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pkgs.lib.getDev pkgs.mysql.client}/include/mysql"
        export NIX_LDFLAGS="$NIX_LDFLAGS -L${pkgs.lib.getLib pkgs.mysql.client}/lib/mysql"
      '';
    };
  };
  clx-truetype = skipBuildPhase;
  query-fs = x: {
    overrides = y: (x.overrides y) // {
      linkedSystems = [];
      postInstall = ((x.overrides y).postInstall or "") + ''
        export CL_SOURCE_REGISTRY="$CL_SOURCE_REGISTRY:$out/lib/common-lisp/query-fs"
	export HOME=$PWD
	build-with-lisp.sh sbcl \
	  ":query-fs $(echo "$linkedSystems" | sed -re 's/(^| )([^ :])/ :\2/g')" \
	  "$out/bin/query-fs" \
	  "(query-fs:run-fs-with-cmdline-args)"
      '';
    };
  };
  cffi = multiOverride [(addNativeLibs [pkgs.libffi])
    (addDeps (with qlnp; [uffi uiop trivial-features]))];
  cl-vectors = addDeps (with qlnp; [zpb-ttf]);
  cl-paths-ttf = addDeps (with qlnp; [zpb-ttf]);
  "3bmd" = addDeps (with qlnp; [esrap split-sequence]);
  cl-dbi = addDeps (with qlnp; [
    cl-syntax cl-syntax-annot split-sequence closer-mop bordeaux-threads
  ]);
  dbd-sqlite3 = addDeps (with qlnp; [cl-dbi]);
  dbd-postgres = addDeps (with qlnp; [cl-dbi]);
  dbd-mysql = addDeps (with qlnp; [cl-dbi]);
  cl-mysql = addNativeLibs [pkgs.mysql];
  cl-ppcre-template = x: {
    overrides = y: (x.overrides y) // {
      postPatch = ''
        ln -s lib-dependent/*.asd .
      '';
    };
    propagatedBuildInputs = (x.propagatedBuildInputs or []) ++ (with qlnp; [
      cl-ppcre
    ]);
  };
  cl-unification = addDeps (with qlnp; [cl-ppcre]);
  cl-syntax-annot = addDeps (with qlnp; [cl-syntax]);
  cl-syntax-anonfun = addDeps (with qlnp; [cl-syntax]);
  cl-syntax-markup = addDeps (with qlnp; [cl-syntax]);
  cl-test-more = addDeps (with qlnp; [prove]);
  babel-streams = addDeps (with qlnp; [babel trivial-gray-streams]);
  babel = addDeps (with qlnp; [trivial-features alexandria]);
  plump = addDeps (with qlnp; [array-utils trivial-indent]);
  sqlite = addNativeLibs [pkgs.sqlite];
  uiop = x: {
    testSystems = (x.testSystems or ["uiop"]) ++ [
      "uiop/version"
    ];
    overrides = y: (x.overrides y) // {
      postInstall = ((x.overrides y).postInstall or "") + ''
        cp -r "${pkgs.asdf}/lib/common-lisp/asdf/uiop/contrib" "$out/lib/common-lisp/uiop"
      '';
    };
  };
  cl-containers = x: {
    overrides = y: (x.overrides y) // {
      postConfigure = "rm GNUmakefile";
    };
  };
  esrap = addDeps (with qlnp; [alexandria]);
  fast-io = addDeps (with qlnp; [
    alexandria trivial-gray-streams static-vectors
  ]);
  hu_dot_dwim_dot_def = addDeps (with qlnp; [
    hu_dot_dwim_dot_asdf alexandria anaphora iterate metabang-bind
  ]);
  ironclad = addDeps (with qlnp; [nibbles flexi-streams]);
  ixf = addDeps (with qlnp; [
    split-sequence md5 alexandria babel local-time cl-ppcre ieee-floats
  ]);
  jonathan = addDeps (with qlnp; [
    cl-syntax cl-syntax-annot fast-io proc-parse cl-ppcre
  ]);
  local-time = addDeps (with qlnp; [cl-fad]);
  lquery = addDeps (with qlnp; [array-utils form-fiddle plump clss]);
  clss = addDeps (with qlnp; [array-utils plump]);
  form-fiddle = addDeps (with qlnp; [documentation-utils]);
  documentation-utils = addDeps (with qlnp; [trivial-indent]);
  mssql = x: {
    testSystems = [];
  };
  cl-postgres = addDeps (with qlnp; [cl-ppcre md5]);
  postmodern = addDeps (with qlnp; [md5]);
}
