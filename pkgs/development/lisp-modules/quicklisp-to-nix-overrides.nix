{pkgs, clwrapper, quicklisp-to-nix-packages}:
let
  addNativeLibs = libs: x: { propagatedBuildInputs = libs; };
  skipBuildPhase = x: {
    overrides = y: ((x.overrides y) // { buildPhase = "true"; });
  };
  multiOverride = l: x: if l == [] then {} else
    ((builtins.head l) x) // (multiOverride (builtins.tail l) x);
  lispName = (clwrapper.lisp.pname or (builtins.parseDrvName clwrapper.lisp.name).name);
  ifLispIn = l: f: if (pkgs.lib.elem lispName l) then f else (x: {});
  ifLispNotIn = l: f: if ! (pkgs.lib.elem lispName l) then f else (x: {});
  extraLispDeps = l: x: { deps = x.deps ++ l; };
in
{
  stumpwm = x:{
    overrides = y: (x.overrides y) // {
      linkedSystems = [];
      preConfigure = ''
        export configureFlags="$configureFlags --with-$NIX_LISP=common-lisp.sh";
      '';
      postInstall = ''
        export NIX_LISP_PRELAUNCH_HOOK="nix_lisp_build_system stumpwm \
                '(function stumpwm:stumpwm)' '$linkedSystems'"
        "$out/bin/stumpwm-lisp-launcher.sh"

        cp "$out/lib/common-lisp/stumpwm/stumpwm" "$out/bin"
      '';
    };
  };
  iterate = multiOverride [ skipBuildPhase
    (ifLispNotIn ["sbcl" "gcl"] (x: { parasites=[]; }))];
  cl-fuse = x: {
    propagatedBuildInputs = [pkgs.fuse];
    overrides = y : (x.overrides y) // {
      configurePhase = ''
        export makeFlags="$makeFlags LISP=common-lisp.sh"
      '';
      preInstall = ''
        type gcc
        mkdir -p "$out/lib/common-lisp/"
        cp -r . "$out/lib/common-lisp/cl-fuse/"
        "gcc" "-x" "c" "$out/lib/common-lisp/cl-fuse/fuse-launcher.c-minus" "-fPIC" "--shared" "-lfuse" "-o" "$out/lib/common-lisp/cl-fuse/libfuse-launcher.so"
      '';
    };
  };
  hunchentoot = addNativeLibs [pkgs.openssl];
  iolib = x: {
    propagatedBuildInputs = (x.propagatedBuildInputs or [])
     ++ (with pkgs; [libfixposix gcc])
     ;
    overrides = y: (x.overrides y) // {
      prePatch = ''
        sed 's|default \"libfixposix\"|default \"${pkgs.libfixposix}/lib/libfixposix\"|' -i src/syscalls/ffi-functions-unix.lisp
        # Socket tests don't work because they try to access the internet
        sed 's/(:file "sockets" :depends-on ("pkgdcl" "defsuites"))//' -i iolib.asd
      '';
    };

  };
  cxml = skipBuildPhase;
  wookie = addNativeLibs (with pkgs; [libuv openssl]);
  lev = addNativeLibs [pkgs.libev];
  cl_plus_ssl = x: rec {
    propagatedBuildInputs = [pkgs.openssl];
    overrides = y: (x.overrides y) // {
      prePatch = ''
        sed 's|libssl.so|${pkgs.lib.getLib pkgs.openssl}/lib/libssl.so|' -i src/reload.lisp
      '';
    };
  };
  cl-colors = skipBuildPhase;
  cl-libuv = addNativeLibs [pkgs.libuv];
  cl-async-ssl = addNativeLibs [pkgs.openssl (import ./openssl-lib-marked.nix)];
  cl-async-test = addNativeLibs [pkgs.openssl];
  clsql = multiOverride [ (x: {
    propagatedBuildInputs = with pkgs; [libmysqlclient postgresql sqlite zlib];
    overrides = y: (x.overrides y) // {
      preConfigure = ((x.overrides y).preConfigure or "") + ''
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pkgs.libmysqlclient}/include/mysql"
        export NIX_LDFLAGS="$NIX_LDFLAGS -L${pkgs.libmysqlclient}/lib/mysql"
      '';};})
    (ifLispIn ["ecl" "clisp"] (x: {
       deps = pkgs.lib.filter (x: x.outPath != quicklisp-to-nix-packages.uffi.outPath)
         (x.deps ++ (with quicklisp-to-nix-packages; [cffi-uffi-compat]));
       overrides = y: (x.overrides y) // {
         postUnpack = ''
           sed -e '1i(cl:push :clsql-cffi cl:*features*)' -i "$sourceRoot/clsql.asd"
         '';
       };
    }))
  ];
  clsql-postgresql-socket = ifLispIn ["ecl" "clisp"] (x: {
       deps = pkgs.lib.filter (x: x.outPath != quicklisp-to-nix-packages.uffi.outPath)
         (x.deps ++ (with quicklisp-to-nix-packages; [cffi-uffi-compat]));
       overrides = y: (x.overrides y) // {
         postUnpack = ''
           sed -e '1i(cl:push :clsql-cffi cl:*features*)' -i "$sourceRoot/clsql-postgresql-socket.asd"
         '';
       };
    });
  clx-truetype = skipBuildPhase;
  query-fs = x: {
    overrides = y: (x.overrides y) // {
      linkedSystems = [];
      postInstall = ((x.overrides y).postInstall or "") + ''
        export NIX_LISP_ASDF_PATHS="$NIX_LISP_ASDF_PATHS
$out/lib/common-lisp/query-fs"
        export HOME=$PWD
        export NIX_LISP_PRELAUNCH_HOOK="nix_lisp_build_system query-fs \
                    '(function query-fs:run-fs-with-cmdline-args)' '$linkedSystems'"
        "$out/bin/query-fs-lisp-launcher.sh"
        cp "$out/lib/common-lisp/query-fs/query-fs" "$out/bin/"
      '';
    };
  };
  cffi = addNativeLibs [pkgs.libffi];
  cl-mysql = x: {
    propagatedBuildInputs = [pkgs.libmysqlclient];
    overrides = y: (x.overrides y) // {
      prePatch = ((x.overrides y).prePatch or "") + ''
        sed -i 's,libmysqlclient_r,${pkgs.libmysqlclient}/lib/mysql/libmysqlclient_r,' system.lisp
      '';
    };
  };
  cl-ppcre-template = x: {
    overrides = y: (x.overrides y) // {
      postPatch = ''
        ln -s lib-dependent/*.asd .
      '';
    };
  };
  sqlite = x: {
    propagatedBuildInputs = [pkgs.sqlite];
    overrides = y: (x.overrides y) // {
      prePatch = ((x.overrides y).preConfigure or "") + ''
        sed 's|libsqlite3|${pkgs.sqlite.out}/lib/libsqlite3|' -i sqlite-ffi.lisp
      '';
    };
  };
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
  simple-date = x: {
    deps = with quicklisp-to-nix-packages; [
      fiveam md5 usocket
    ];
    parasites = [
      # Needs pomo? Wants to do queries unconditionally?
      # "simple-date/tests"
    ];
  };
  cl-postgres = x: {
    deps = pkgs.lib.filter (x: x.outPath != quicklisp-to-nix-packages.simple-date.outPath) x.deps;
    parasites = (x.parasites or []) ++ [
      "simple-date" "simple-date/postgres-glue"
    ];
    asdFilesToKeep = x.asdFilesToKeep ++ ["simple-date.asd"];
  };
  buildnode = x: {
    deps = pkgs.lib.filter (x: x.name != quicklisp-to-nix-packages.buildnode-xhtml.name) x.deps;
    parasites = pkgs.lib.filter (x: x!= "buildnode-test") x.parasites;
  };
  postmodern = x: {
    asdFilesToKeep = (x.asdFilesToKeep or []) ++ ["postmodern.asd" "simple-date.asd"];
    parasites = (pkgs.lib.filter (x: x!= "postmodern/tests") x.parasites) ++
      ["simple-date/postgres-glue"];
    deps = pkgs.lib.filter
      (x: x.name != quicklisp-to-nix-packages.simple-date.name)
      x.deps;
  };
  s-sql = x: {
    parasites = pkgs.lib.filter (x: x!= "s-sql/tests") x.parasites;
    deps = pkgs.lib.filter
      (x: x.name != quicklisp-to-nix-packages.postmodern.name)
      x.deps;
  };
  split-sequence = x: {
    overrides = y: (x.overrides y) // {
      preConfigure = ''
        sed -i -e '/:components/i:serial t' split-sequence.asd
      '';
    };
  };
  cl-store = x: {
    overrides = y: (x.overrides y) // {
      postPatch = ''
        sed -i -e 's/:initform "Unknown" /:initform #:|Unknown| /' backends.lisp
      '';
    };
  };
  dbi = x: {
    parasites = [];
    deps = pkgs.lib.filter
      (x:
        (
          x.name != quicklisp-to-nix-packages.dbd-mysql.name &&
          x.name != quicklisp-to-nix-packages.dbd-postgres.name &&
          x.name != quicklisp-to-nix-packages.dbd-sqlite3.name &&
          x.name != quicklisp-to-nix-packages.dbi-test.name &&
          true))
      x.deps;
  };
  cl-cffi-gtk-glib = addNativeLibs [pkgs.glib];
  cl-cffi-gtk-gdk-pixbuf = addNativeLibs [pkgs.gdk-pixbuf];
  cl-cffi-gtk-cairo = addNativeLibs [pkgs.cairo];
  cl-cffi-gtk-pango = addNativeLibs [pkgs.pango];
  cl-cffi-gtk-gdk = addNativeLibs [pkgs.gtk3];
  cl-cffi-gtk-gtk3 = addNativeLibs [pkgs.gtk3];
  cl-webkit2 = addNativeLibs [pkgs.webkitgtk];
  clfswm = x: {
    overrides = y: (x.overrides y) // {
      postInstall = ''
        export NIX_LISP_PRELAUNCH_HOOK="nix_lisp_build_system clfswm '(function clfswm:main)'"
        "$out/bin/clfswm-lisp-launcher.sh"

        cp "$out/lib/common-lisp/clfswm/clfswm" "$out/bin"
      '';
    };
  };
  woo = ifLispNotIn ["sbcl" "gcl"]
    (extraLispDeps (with quicklisp-to-nix-packages; [cl-speedy-queue]));
  cl-syslog = x: {
    overrides = y: (x.overrides y) // {
      postUnpack = ''
        sed -e '1a:serial t' -i $sourceRoot/cl-syslog.asd
      '';
    };
  };
  log4cl = ifLispNotIn ["sbcl" "gcl"]
    (extraLispDeps (with quicklisp-to-nix-packages; [cl-syslog]));
  md5 = ifLispNotIn ["sbcl" "ccl" "gcl"]
    (extraLispDeps (with quicklisp-to-nix-packages; [flexi-streams]));
  cl-gobject-introspection = addNativeLibs (with pkgs; [glib gobject-introspection]);
  generic-cl = x: { parasites = []; };
  static-dispatch = x: {
    overrides = y: (x.overrides y) // {
      parasites = [];
      # workaround for https://github.com/alex-gutev/static-dispatch/issues/12
      postUnpack = ''
        sed -e '/^(in-package / a (eval-when (:compile-toplevel :load-toplevel :execute)' \
            -e '$a)' \
            -i $sourceRoot/src/combin.lisp
      '';
    };
  };
  lla = addNativeLibs [ pkgs.openblas ];
#  cl-opengl = addNativeLibs [ pkgs.libGL pkgs.glfw ];
}
