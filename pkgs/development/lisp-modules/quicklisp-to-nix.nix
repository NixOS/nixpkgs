{stdenv, fetchurl, pkgs, clwrapper}:
let quicklisp-to-nix-packages = rec {
  inherit stdenv fetchurl clwrapper pkgs quicklisp-to-nix-packages;

  callPackage = pkgs.lib.callPackageWith quicklisp-to-nix-packages;
  buildLispPackage = callPackage ./define-package.nix;
  qlOverrides = callPackage ./quicklisp-to-nix-overrides.nix {};

  "iolib/conf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/conf" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_conf.nix {
         inherit fetchurl;
       }));
  "iolib_slash_conf" = quicklisp-to-nix-packages."iolib/conf";


  "iolib/asdf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/asdf" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_asdf.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));
  "iolib_slash_asdf" = quicklisp-to-nix-packages."iolib/asdf";


  "swap-bytes" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."swap-bytes" or (x: {}))
       (import ./quicklisp-to-nix-output/swap-bytes.nix {
         inherit fetchurl;
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "idna" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."idna" or (x: {}))
       (import ./quicklisp-to-nix-output/idna.nix {
         inherit fetchurl;
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "iolib/grovel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/grovel" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_grovel.nix {
         inherit fetchurl;
           "iolib/asdf" = quicklisp-to-nix-packages."iolib/asdf";
           "iolib/base" = quicklisp-to-nix-packages."iolib/base";
           "iolib/conf" = quicklisp-to-nix-packages."iolib/conf";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));
  "iolib_slash_grovel" = quicklisp-to-nix-packages."iolib/grovel";


  "iolib/syscalls" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/syscalls" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_syscalls.nix {
         inherit fetchurl;
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "iolib/base" = quicklisp-to-nix-packages."iolib/base";
           "iolib/grovel" = quicklisp-to-nix-packages."iolib/grovel";
       }));
  "iolib_slash_syscalls" = quicklisp-to-nix-packages."iolib/syscalls";


  "iolib/common-lisp" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/common-lisp" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_common-lisp.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));
  "iolib_slash_common-lisp" = quicklisp-to-nix-packages."iolib/common-lisp";


  "split-sequence" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."split-sequence" or (x: {}))
       (import ./quicklisp-to-nix-output/split-sequence.nix {
         inherit fetchurl;
       }));


  "trivial-garbage" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-garbage" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-garbage.nix {
         inherit fetchurl;
       }));


  "trivial-gray-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-gray-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-gray-streams.nix {
         inherit fetchurl;
       }));


  "babel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."babel" or (x: {}))
       (import ./quicklisp-to-nix-output/babel.nix {
         inherit fetchurl;
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "uiop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uiop" or (x: {}))
       (import ./quicklisp-to-nix-output/uiop.nix {
         inherit fetchurl;
       }));


  "iolib/sockets" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/sockets" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_sockets.nix {
         inherit fetchurl;
           "iolib/base" = quicklisp-to-nix-packages."iolib/base";
           "iolib/syscalls" = quicklisp-to-nix-packages."iolib/syscalls";
           "iolib/streams" = quicklisp-to-nix-packages."iolib/streams";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "iolib/grovel" = quicklisp-to-nix-packages."iolib/grovel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "idna" = quicklisp-to-nix-packages."idna";
           "swap-bytes" = quicklisp-to-nix-packages."swap-bytes";
       }));
  "iolib_slash_sockets" = quicklisp-to-nix-packages."iolib/sockets";


  "iolib/streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/streams" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_streams.nix {
         inherit fetchurl;
           "iolib/base" = quicklisp-to-nix-packages."iolib/base";
           "iolib/multiplex" = quicklisp-to-nix-packages."iolib/multiplex";
           "cffi" = quicklisp-to-nix-packages."cffi";
       }));
  "iolib_slash_streams" = quicklisp-to-nix-packages."iolib/streams";


  "iolib/multiplex" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/multiplex" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_multiplex.nix {
         inherit fetchurl;
           "iolib/base" = quicklisp-to-nix-packages."iolib/base";
           "iolib/syscalls" = quicklisp-to-nix-packages."iolib/syscalls";
           "cffi" = quicklisp-to-nix-packages."cffi";
       }));
  "iolib_slash_multiplex" = quicklisp-to-nix-packages."iolib/multiplex";


  "iolib/base" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib/base" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_slash_base.nix {
         inherit fetchurl;
           "iolib/common-lisp" = quicklisp-to-nix-packages."iolib/common-lisp";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));
  "iolib_slash_base" = quicklisp-to-nix-packages."iolib/base";


  "chipz" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chipz" or (x: {}))
       (import ./quicklisp-to-nix-output/chipz.nix {
         inherit fetchurl;
       }));


  "puri" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."puri" or (x: {}))
       (import ./quicklisp-to-nix-output/puri.nix {
         inherit fetchurl;
       }));


  "trivial-features" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-features" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-features.nix {
         inherit fetchurl;
       }));


  "usocket" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."usocket" or (x: {}))
       (import ./quicklisp-to-nix-output/usocket.nix {
         inherit fetchurl;
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "rfc2388" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."rfc2388" or (x: {}))
       (import ./quicklisp-to-nix-output/rfc2388.nix {
         inherit fetchurl;
       }));


  "md5" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."md5" or (x: {}))
       (import ./quicklisp-to-nix-output/md5.nix {
         inherit fetchurl;
       }));


  "cl+ssl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl+ssl" or (x: {}))
       (import ./quicklisp-to-nix-output/cl+ssl.nix {
         inherit fetchurl;
           "cffi" = quicklisp-to-nix-packages."cffi";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "flexi-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."flexi-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/flexi-streams.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cl-fad" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fad" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fad.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "cl-base64" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-base64" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-base64.nix {
         inherit fetchurl;
       }));


  "chunga" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chunga" or (x: {}))
       (import ./quicklisp-to-nix-output/chunga.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "trivial-utf-8" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-utf-8" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-utf-8.nix {
         inherit fetchurl;
       }));


  "iterate" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iterate" or (x: {}))
       (import ./quicklisp-to-nix-output/iterate.nix {
         inherit fetchurl;
       }));


  "trivial-backtrace" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-backtrace" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-backtrace.nix {
         inherit fetchurl;
       }));


  "bordeaux-threads" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."bordeaux-threads" or (x: {}))
       (import ./quicklisp-to-nix-output/bordeaux-threads.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "cl-utilities" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-utilities" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-utilities.nix {
         inherit fetchurl;
       }));


  "cffi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "babel" = quicklisp-to-nix-packages."babel";
       }));


  "clx" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clx" or (x: {}))
       (import ./quicklisp-to-nix-output/clx.nix {
         inherit fetchurl;
       }));


  "cl-ppcre" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ppcre" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ppcre.nix {
         inherit fetchurl;
       }));


  "alexandria" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."alexandria" or (x: {}))
       (import ./quicklisp-to-nix-output/alexandria.nix {
         inherit fetchurl;
       }));


  "iolib" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib.nix {
         inherit fetchurl;
           "iolib/base" = quicklisp-to-nix-packages."iolib/base";
           "iolib/multiplex" = quicklisp-to-nix-packages."iolib/multiplex";
           "iolib/streams" = quicklisp-to-nix-packages."iolib/streams";
           "iolib/sockets" = quicklisp-to-nix-packages."iolib/sockets";
       }));


  "drakma" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."drakma" or (x: {}))
       (import ./quicklisp-to-nix-output/drakma.nix {
         inherit fetchurl;
           "puri" = quicklisp-to-nix-packages."puri";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "chipz" = quicklisp-to-nix-packages."chipz";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "cl+ssl" = quicklisp-to-nix-packages."cl+ssl";
       }));


  "external-program" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."external-program" or (x: {}))
       (import ./quicklisp-to-nix-output/external-program.nix {
         inherit fetchurl;
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "hunchentoot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hunchentoot" or (x: {}))
       (import ./quicklisp-to-nix-output/hunchentoot.nix {
         inherit fetchurl;
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "cl+ssl" = quicklisp-to-nix-packages."cl+ssl";
           "md5" = quicklisp-to-nix-packages."md5";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "esrap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."esrap" or (x: {}))
       (import ./quicklisp-to-nix-output/esrap.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "cl-fuse" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fuse" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fuse.nix {
         inherit fetchurl;
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
       }));


  "stumpwm" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."stumpwm" or (x: {}))
       (import ./quicklisp-to-nix-output/stumpwm.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "clx" = quicklisp-to-nix-packages."clx";
       }));


}; in quicklisp-to-nix-packages
