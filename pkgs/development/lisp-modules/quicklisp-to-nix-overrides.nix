{pkgs, buildLispPackage, quicklisp-to-nix-packages}:
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
  stumpwm = addDeps (with qlnp; [alexandria cl-ppcre clx]);
  iterate = skipBuildPhase;
  cl-fuse = x: {
    propagatedBuildInputs = [pkgs.fuse];
    overrides = y : (x.overrides y) // {
      configurePhase = ''
        export CL_SOURCE_REGISTRY="$CL_SOURCE_REGISTRY:$PWD"
        export makeFlags="$makeFlags LISP=common-lisp.sh"
      '';
    };
  };
  hunchentoot = addNativeLibs [pkgs.openssl];
  iolib = addNativeLibs [pkgs.libfixposix pkgs.gcc];
  cl-unicode = addDeps (with qlnp; [cl-ppcre flexi-streams]);
  clack =  addDeps (with qlnp;[lack bordeaux-threads prove]);
  clack-v1-compat =  addDeps (with qlnp;[
    lack bordeaux-threads prove usocket dexador http-body trivial-backtrace
    marshal local-time cl-base64 cl-ppcre quri trivial-mimes trivial-types
    flexi-streams circular-streams ironclad cl-syntax-annot alexandria
    split-sequence
  ]);
  cxml = skipBuildPhase;
  cxml-xml = skipBuildPhase;
  cxml-dom = skipBuildPhase;
  cxml-klacks = skipBuildPhase;
  cxml-test = skipBuildPhase;
  wookie = multiOverride [(addDeps (with qlnp; [
      alexandria blackbird cl-async chunga fast-http quri babel cl-ppcre
      cl-fad fast-io vom do-urlencode
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
  cl-async-base = addDeps (with qlnp; [
    cffi fast-io vom cl-libuv cl-ppcre trivial-features static-vectors
    trivial-gray-streams babel
  ]);
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
}
