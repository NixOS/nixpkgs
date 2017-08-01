{pkgs, buildLispPackage, clwrapper, quicklisp-to-nix-packages}:
let
  addDeps = newdeps: x: {deps = x.deps ++ newdeps;};
  addNativeLibs = libs: x: { propagatedBuildInputs = libs; };
  skipBuildPhase = x: {
    overrides = y: ((x.overrides y) // { buildPhase = "true"; });
  };
  multiOverride = l: x: if l == [] then {} else
    ((builtins.head l) x) // (multiOverride (builtins.tail l) x);
in
{
  stumpwm = x:{
    overrides = y: (x.overrides y) // {
      preConfigure = ''
        export configureFlags="$configureFlags --with-$NIX_LISP=common-lisp.sh";
      '';
      postInstall = ''
        "$out/bin/stumpwm-lisp-launcher.sh" --eval '(asdf:make :stumpwm)' \
          --eval '(setf (asdf/system:component-entry-point (asdf:find-system :stumpwm)) (function stumpwm:stumpwm))' \
          --eval '(asdf:perform (quote asdf:program-op) :stumpwm)'

        cp "$out/lib/common-lisp/stumpwm/stumpwm" "$out/bin"
      '';
    };
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
     ;
  };
  cxml = skipBuildPhase;
  wookie = addNativeLibs (with pkgs; [libuv openssl]);
  lev = addNativeLibs [pkgs.libev];
  "cl+ssl" = addNativeLibs [pkgs.openssl];
  cl-colors = skipBuildPhase;
  cl-libuv = addNativeLibs [pkgs.libuv];
  cl-async-ssl = addNativeLibs [pkgs.openssl];
  cl-async-test = addNativeLibs [pkgs.openssl];
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
  cffi = addNativeLibs [pkgs.libffi];
  cl-mysql = addNativeLibs [pkgs.mysql];
  cl-ppcre-template = x: {
    overrides = y: (x.overrides y) // {
      postPatch = ''
        ln -s lib-dependent/*.asd .
      '';
    };
  };
  sqlite = addNativeLibs [pkgs.sqlite];
  uiop = x: {
    parasites = (x.parasites or []) ++ [
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
  mssql = addNativeLibs [pkgs.freetds];
}
