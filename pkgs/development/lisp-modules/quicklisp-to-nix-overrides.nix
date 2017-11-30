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
        export makeFlags="$makeFlags LISP=common-lisp.sh"
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
        export NIX_LISP_ASDF_PATHS="$NIX_LISP_ASDF_PATHS
$out/lib/common-lisp/query-fs"
	export HOME=$PWD
        "$out/bin/query-fs-lisp-launcher.sh" --eval '(asdf:make :query-fs)' \
          --eval "(progn $(for i in $linkedSystems; do echo "(asdf:make :$i)"; done) )" \
          --eval '(setf (asdf/system:component-entry-point (asdf:find-system :query-fs))
                           (function query-fs:run-fs-with-cmdline-args))' \
          --eval '(asdf:perform (quote asdf:program-op) :query-fs)'
	cp "$out/lib/common-lisp/query-fs/query-fs" "$out/bin/"
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
  swank = x: {
    overrides = y: (x.overrides y) // {
      postPatch = ''
        patch <<EOD
        --- swank-loader.lisp	2017-08-30 16:46:16.554076684 -0700
        +++ swank-loader-new.lisp	2017-08-30 16:49:23.333450928 -0700
        @@ -155,7 +155,7 @@
                          ,(unique-dir-name)))
            (user-homedir-pathname)))
         
        -(defvar *fasl-directory* (default-fasl-dir)
        +(defvar *fasl-directory* #P"$out/lib/common-lisp/swank/fasl/"
           "The directory where fasl files should be placed.")
         
         (defun binary-pathname (src-pathname binary-dir)
        @@ -277,12 +277,7 @@
                          (contrib-dir src-dir))))
         
         (defun delete-stale-contrib-fasl-files (swank-files contrib-files fasl-dir)
        -  (let ((newest (reduce #'max (mapcar #'file-write-date swank-files))))
        -    (dolist (src contrib-files)
        -      (let ((fasl (binary-pathname src fasl-dir)))
        -        (when (and (probe-file fasl)
        -                   (<= (file-write-date fasl) newest))
        -          (delete-file fasl))))))
        +  (declare (ignore swank-files contrib-files fasl-dir)))
         
         (defun compile-contribs (&key (src-dir (contrib-dir *source-directory*))
                                    (fasl-dir (contrib-dir *fasl-directory*))
        EOD
      '';
    };
  };
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
  cl-unification = x: {
    asdFilesToKeep = (x.asdFilesToKeep or []) ++ [
      "cl-unification-lib.asd"
    ];
  };
}
