{stdenv, fetchurl, pkgs, clwrapper}:
let quicklisp-to-nix-packages = rec {
  inherit stdenv fetchurl clwrapper pkgs quicklisp-to-nix-packages;

  callPackage = pkgs.lib.callPackageWith quicklisp-to-nix-packages;
  buildLispPackage = callPackage ./define-package.nix;
  qlOverrides = callPackage ./quicklisp-to-nix-overrides.nix {};

  "xpath_slash_test" = quicklisp-to-nix-packages."xpath";


  "unit-test" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."unit-test" or (x: {}))
       (import ./quicklisp-to-nix-output/unit-test.nix {
         inherit fetchurl;
       }));


  "type-i" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."type-i" or (x: {}))
       (import ./quicklisp-to-nix-output/type-i.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
       }));


  "trivial-macroexpand-all" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-macroexpand-all" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-macroexpand-all.nix {
         inherit fetchurl;
       }));


  "trivial-file-size" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-file-size" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-file-size.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "trivial-cltl2" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-cltl2" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-cltl2.nix {
         inherit fetchurl;
       }));


  "trivia_dot_trivial" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivia_dot_trivial" or (x: {}))
       (import ./quicklisp-to-nix-output/trivia_dot_trivial.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
       }));


  "trivia_dot_quasiquote" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivia_dot_quasiquote" or (x: {}))
       (import ./quicklisp-to-nix-output/trivia_dot_quasiquote.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fare-quasiquote" = quicklisp-to-nix-packages."fare-quasiquote";
           "fare-quasiquote-readtable" = quicklisp-to-nix-packages."fare-quasiquote-readtable";
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
       }));


  "trivia_dot_level2" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivia_dot_level2" or (x: {}))
       (import ./quicklisp-to-nix-output/trivia_dot_level2.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
       }));


  "trivia_dot_level1" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivia_dot_level1" or (x: {}))
       (import ./quicklisp-to-nix-output/trivia_dot_level1.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
       }));


  "trivia_dot_level0" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivia_dot_level0" or (x: {}))
       (import ./quicklisp-to-nix-output/trivia_dot_level0.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "trivia_dot_balland2006" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivia_dot_balland2006" or (x: {}))
       (import ./quicklisp-to-nix-output/trivia_dot_balland2006.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "parse-declarations-1_dot_0" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parse-declarations-1_dot_0" or (x: {}))
       (import ./quicklisp-to-nix-output/parse-declarations-1_dot_0.nix {
         inherit fetchurl;
       }));


  "introspect-environment" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."introspect-environment" or (x: {}))
       (import ./quicklisp-to-nix-output/introspect-environment.nix {
         inherit fetchurl;
       }));


  "global-vars" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."global-vars" or (x: {}))
       (import ./quicklisp-to-nix-output/global-vars.nix {
         inherit fetchurl;
       }));


  "fare-utils" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-utils" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-utils.nix {
         inherit fetchurl;
       }));


  "fare-quasiquote-readtable" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-quasiquote-readtable" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-quasiquote-readtable.nix {
         inherit fetchurl;
           "fare-quasiquote" = quicklisp-to-nix-packages."fare-quasiquote";
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "fare-quasiquote-optima" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-quasiquote-optima" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-quasiquote-optima.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fare-quasiquote" = quicklisp-to-nix-packages."fare-quasiquote";
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
           "optima" = quicklisp-to-nix-packages."optima";
       }));


  "fare-quasiquote-extras" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-quasiquote-extras" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-quasiquote-extras.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fare-quasiquote" = quicklisp-to-nix-packages."fare-quasiquote";
           "fare-quasiquote-optima" = quicklisp-to-nix-packages."fare-quasiquote-optima";
           "fare-quasiquote-readtable" = quicklisp-to-nix-packages."fare-quasiquote-readtable";
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "optima" = quicklisp-to-nix-packages."optima";
       }));


  "fare-quasiquote" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-quasiquote" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-quasiquote.nix {
         inherit fetchurl;
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
       }));


  "stefil" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."stefil" or (x: {}))
       (import ./quicklisp-to-nix-output/stefil.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
           "swank" = quicklisp-to-nix-packages."swank";
       }));


  "lfarm-common" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lfarm-common" or (x: {}))
       (import ./quicklisp-to-nix-output/lfarm-common.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-store" = quicklisp-to-nix-packages."cl-store";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "rt" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."rt" or (x: {}))
       (import ./quicklisp-to-nix-output/rt.nix {
         inherit fetchurl;
       }));


  "iolib_dot_grovel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib_dot_grovel" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_dot_grovel.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "iolib_dot_asdf" = quicklisp-to-nix-packages."iolib_dot_asdf";
           "iolib_dot_base" = quicklisp-to-nix-packages."iolib_dot_base";
           "iolib_dot_common-lisp" = quicklisp-to-nix-packages."iolib_dot_common-lisp";
           "iolib_dot_conf" = quicklisp-to-nix-packages."iolib_dot_conf";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "iolib_dot_conf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib_dot_conf" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_dot_conf.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "iolib_dot_asdf" = quicklisp-to-nix-packages."iolib_dot_asdf";
       }));


  "iolib_dot_common-lisp" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib_dot_common-lisp" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_dot_common-lisp.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "iolib_dot_asdf" = quicklisp-to-nix-packages."iolib_dot_asdf";
           "iolib_dot_conf" = quicklisp-to-nix-packages."iolib_dot_conf";
       }));


  "iolib_dot_base" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib_dot_base" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_dot_base.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "iolib_dot_asdf" = quicklisp-to-nix-packages."iolib_dot_asdf";
           "iolib_dot_common-lisp" = quicklisp-to-nix-packages."iolib_dot_common-lisp";
           "iolib_dot_conf" = quicklisp-to-nix-packages."iolib_dot_conf";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "iolib_dot_asdf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib_dot_asdf" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib_dot_asdf.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "net_dot_didierverna_dot_asdf-flv" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."net_dot_didierverna_dot_asdf-flv" or (x: {}))
       (import ./quicklisp-to-nix-output/net_dot_didierverna_dot_asdf-flv.nix {
         inherit fetchurl;
       }));


  "cl-xmlspam" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-xmlspam" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-xmlspam.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "puri" = quicklisp-to-nix-packages."puri";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "asdf-package-system" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."asdf-package-system" or (x: {}))
       (import ./quicklisp-to-nix-output/asdf-package-system.nix {
         inherit fetchurl;
       }));


  "cl-postgres" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-postgres" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-postgres.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "md5" = quicklisp-to-nix-packages."md5";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "xpath" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."xpath" or (x: {}))
       (import ./quicklisp-to-nix-output/xpath.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
           "puri" = quicklisp-to-nix-packages."puri";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "yacc" = quicklisp-to-nix-packages."yacc";
       }));


  "cxml-stp" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml-stp" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml-stp.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
           "puri" = quicklisp-to-nix-packages."puri";
           "rt" = quicklisp-to-nix-packages."rt";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "xpath" = quicklisp-to-nix-packages."xpath";
           "xpath_slash_test" = quicklisp-to-nix-packages."xpath_slash_test";
           "yacc" = quicklisp-to-nix-packages."yacc";
       }));


  "yacc" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."yacc" or (x: {}))
       (import ./quicklisp-to-nix-output/yacc.nix {
         inherit fetchurl;
       }));


  "symbol-munger" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."symbol-munger" or (x: {}))
       (import ./quicklisp-to-nix-output/symbol-munger.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "iterate" = quicklisp-to-nix-packages."iterate";
       }));


  "collectors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."collectors" or (x: {}))
       (import ./quicklisp-to-nix-output/collectors.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-unit2" = quicklisp-to-nix-packages."lisp-unit2";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
       }));


  "buildnode-xhtml" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."buildnode-xhtml" or (x: {}))
       (import ./quicklisp-to-nix-output/buildnode-xhtml.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "buildnode" = quicklisp-to-nix-packages."buildnode";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "closure-html" = quicklisp-to-nix-packages."closure-html";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "puri" = quicklisp-to-nix-packages."puri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swank" = quicklisp-to-nix-packages."swank";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "buildnode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."buildnode" or (x: {}))
       (import ./quicklisp-to-nix-output/buildnode.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "buildnode-xhtml" = quicklisp-to-nix-packages."buildnode-xhtml";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "closure-html" = quicklisp-to-nix-packages."closure-html";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-unit2" = quicklisp-to-nix-packages."lisp-unit2";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "puri" = quicklisp-to-nix-packages."puri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swank" = quicklisp-to-nix-packages."swank";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cl-store" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-store" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-store.nix {
         inherit fetchurl;
           "rt" = quicklisp-to-nix-packages."rt";
       }));


  "cl-paths-ttf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-paths-ttf" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-paths-ttf.nix {
         inherit fetchurl;
           "cl-paths" = quicklisp-to-nix-packages."cl-paths";
           "zpb-ttf" = quicklisp-to-nix-packages."zpb-ttf";
       }));


  "fiasco" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fiasco" or (x: {}))
       (import ./quicklisp-to-nix-output/fiasco.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "clsql-uffi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clsql-uffi" or (x: {}))
       (import ./quicklisp-to-nix-output/clsql-uffi.nix {
         inherit fetchurl;
           "clsql" = quicklisp-to-nix-packages."clsql";
           "uffi" = quicklisp-to-nix-packages."uffi";
       }));


  "cl-paths" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-paths" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-paths.nix {
         inherit fetchurl;
       }));


  "cl-aa" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-aa" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-aa.nix {
         inherit fetchurl;
       }));


  "cl-markup" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-markup" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-markup.nix {
         inherit fetchurl;
       }));


  "cl-anonfun" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-anonfun" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-anonfun.nix {
         inherit fetchurl;
       }));


  "cl-ppcre-test" = quicklisp-to-nix-packages."cl-ppcre";


  "zpb-ttf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."zpb-ttf" or (x: {}))
       (import ./quicklisp-to-nix-output/zpb-ttf.nix {
         inherit fetchurl;
       }));


  "puri" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."puri" or (x: {}))
       (import ./quicklisp-to-nix-output/puri.nix {
         inherit fetchurl;
           "ptester" = quicklisp-to-nix-packages."ptester";
       }));


  "parse-number" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parse-number" or (x: {}))
       (import ./quicklisp-to-nix-output/parse-number.nix {
         inherit fetchurl;
       }));


  "metabang-bind" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."metabang-bind" or (x: {}))
       (import ./quicklisp-to-nix-output/metabang-bind.nix {
         inherit fetchurl;
       }));


  "hu_dot_dwim_dot_stefil" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_stefil" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_stefil.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
       }));


  "closure-common" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."closure-common" or (x: {}))
       (import ./quicklisp-to-nix-output/closure-common.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cl-l10n-cldr" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-l10n-cldr" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-l10n-cldr.nix {
         inherit fetchurl;
       }));


  "string-case" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."string-case" or (x: {}))
       (import ./quicklisp-to-nix-output/string-case.nix {
         inherit fetchurl;
       }));


  "pcall-queue" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."pcall-queue" or (x: {}))
       (import ./quicklisp-to-nix-output/pcall-queue.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "dbi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbi" or (x: {}))
       (import ./quicklisp-to-nix-output/dbi.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "lisp-unit2" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lisp-unit2" or (x: {}))
       (import ./quicklisp-to-nix-output/lisp-unit2.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
       }));


  "cl-interpol" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-interpol" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-interpol.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "lift" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lift" or (x: {}))
       (import ./quicklisp-to-nix-output/lift.nix {
         inherit fetchurl;
       }));


  "ptester" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."ptester" or (x: {}))
       (import ./quicklisp-to-nix-output/ptester.nix {
         inherit fetchurl;
       }));


  "kmrcl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."kmrcl" or (x: {}))
       (import ./quicklisp-to-nix-output/kmrcl.nix {
         inherit fetchurl;
       }));


  "cl-async-util" = quicklisp-to-nix-packages."cl-async";


  "uiop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uiop" or (x: {}))
       (import ./quicklisp-to-nix-output/uiop.nix {
         inherit fetchurl;
       }));


  "trivial-gray-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-gray-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-gray-streams.nix {
         inherit fetchurl;
       }));


  "trivial-garbage" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-garbage" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-garbage.nix {
         inherit fetchurl;
           "rt" = quicklisp-to-nix-packages."rt";
       }));


  "rfc2388" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."rfc2388" or (x: {}))
       (import ./quicklisp-to-nix-output/rfc2388.nix {
         inherit fetchurl;
       }));


  "named-readtables" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."named-readtables" or (x: {}))
       (import ./quicklisp-to-nix-output/named-readtables.nix {
         inherit fetchurl;
       }));


  "myway" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."myway" or (x: {}))
       (import ./quicklisp-to-nix-output/myway.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "map-set" = quicklisp-to-nix-packages."map-set";
           "quri" = quicklisp-to-nix-packages."quri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "md5" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."md5" or (x: {}))
       (import ./quicklisp-to-nix-output/md5.nix {
         inherit fetchurl;
       }));


  "map-set" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."map-set" or (x: {}))
       (import ./quicklisp-to-nix-output/map-set.nix {
         inherit fetchurl;
       }));


  "lack-util" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lack-util" or (x: {}))
       (import ./quicklisp-to-nix-output/lack-util.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "nibbles" = quicklisp-to-nix-packages."nibbles";
       }));


  "lack-middleware-backtrace" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lack-middleware-backtrace" or (x: {}))
       (import ./quicklisp-to-nix-output/lack-middleware-backtrace.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "lack-component" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lack-component" or (x: {}))
       (import ./quicklisp-to-nix-output/lack-component.nix {
         inherit fetchurl;
       }));


  "jonathan" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."jonathan" or (x: {}))
       (import ./quicklisp-to-nix-output/jonathan.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "do-urlencode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."do-urlencode" or (x: {}))
       (import ./quicklisp-to-nix-output/do-urlencode.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "clack-test" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack-test" or (x: {}))
       (import ./quicklisp-to-nix-output/clack-test.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "chipz" = quicklisp-to-nix-packages."chipz";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-ansi-text" = quicklisp-to-nix-packages."cl-ansi-text";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "cl-cookie" = quicklisp-to-nix-packages."cl-cookie";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-reexport" = quicklisp-to-nix-packages."cl-reexport";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "clack" = quicklisp-to-nix-packages."clack";
           "clack-handler-hunchentoot" = quicklisp-to-nix-packages."clack-handler-hunchentoot";
           "clack-socket" = quicklisp-to-nix-packages."clack-socket";
           "dexador" = quicklisp-to-nix-packages."dexador";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "http-body" = quicklisp-to-nix-packages."http-body";
           "hunchentoot" = quicklisp-to-nix-packages."hunchentoot";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "jonathan" = quicklisp-to-nix-packages."jonathan";
           "lack" = quicklisp-to-nix-packages."lack";
           "lack-component" = quicklisp-to-nix-packages."lack-component";
           "lack-middleware-backtrace" = quicklisp-to-nix-packages."lack-middleware-backtrace";
           "lack-util" = quicklisp-to-nix-packages."lack-util";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "md5" = quicklisp-to-nix-packages."md5";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "nibbles" = quicklisp-to-nix-packages."nibbles";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "prove" = quicklisp-to-nix-packages."prove";
           "quri" = quicklisp-to-nix-packages."quri";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "smart-buffer" = quicklisp-to-nix-packages."smart-buffer";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-mimes" = quicklisp-to-nix-packages."trivial-mimes";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "clack-socket" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack-socket" or (x: {}))
       (import ./quicklisp-to-nix-output/clack-socket.nix {
         inherit fetchurl;
       }));


  "clack-handler-hunchentoot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack-handler-hunchentoot" or (x: {}))
       (import ./quicklisp-to-nix-output/clack-handler-hunchentoot.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "clack-socket" = quicklisp-to-nix-packages."clack-socket";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "hunchentoot" = quicklisp-to-nix-packages."hunchentoot";
           "md5" = quicklisp-to-nix-packages."md5";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "cl-syntax" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax.nix {
         inherit fetchurl;
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cl-project" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-project" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-project.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-ansi-text" = quicklisp-to-nix-packages."cl-ansi-text";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "cl-emb" = quicklisp-to-nix-packages."cl-emb";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "prove" = quicklisp-to-nix-packages."prove";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "cl-fad" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fad" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fad.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "unit-test" = quicklisp-to-nix-packages."unit-test";
       }));


  "cl-annot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-annot" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-annot.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "chunga" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chunga" or (x: {}))
       (import ./quicklisp-to-nix-output/chunga.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cffi-toolchain" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi-toolchain" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi-toolchain.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "anaphora" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."anaphora" or (x: {}))
       (import ./quicklisp-to-nix-output/anaphora.nix {
         inherit fetchurl;
           "rt" = quicklisp-to-nix-packages."rt";
       }));


  "vom" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."vom" or (x: {}))
       (import ./quicklisp-to-nix-output/vom.nix {
         inherit fetchurl;
       }));


  "trivial-features" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-features" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-features.nix {
         inherit fetchurl;
       }));


  "s-xml" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."s-xml" or (x: {}))
       (import ./quicklisp-to-nix-output/s-xml.nix {
         inherit fetchurl;
       }));


  "s-sysdeps" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."s-sysdeps" or (x: {}))
       (import ./quicklisp-to-nix-output/s-sysdeps.nix {
         inherit fetchurl;
       }));


  "yason" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."yason" or (x: {}))
       (import ./quicklisp-to-nix-output/yason.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "xsubseq" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."xsubseq" or (x: {}))
       (import ./quicklisp-to-nix-output/xsubseq.nix {
         inherit fetchurl;
       }));


  "xmls" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."xmls" or (x: {}))
       (import ./quicklisp-to-nix-output/xmls.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
       }));


  "xkeyboard" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."xkeyboard" or (x: {}))
       (import ./quicklisp-to-nix-output/xkeyboard.nix {
         inherit fetchurl;
           "clx" = quicklisp-to-nix-packages."clx";
       }));


  "xembed" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."xembed" or (x: {}))
       (import ./quicklisp-to-nix-output/xembed.nix {
         inherit fetchurl;
           "clx" = quicklisp-to-nix-packages."clx";
       }));


  "wookie" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."wookie" or (x: {}))
       (import ./quicklisp-to-nix-output/wookie.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "blackbird" = quicklisp-to-nix-packages."blackbird";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl-async" = quicklisp-to-nix-packages."cl-async";
           "cl-async-base" = quicklisp-to-nix-packages."cl-async-base";
           "cl-async-ssl" = quicklisp-to-nix-packages."cl-async-ssl";
           "cl-async-util" = quicklisp-to-nix-packages."cl-async-util";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "do-urlencode" = quicklisp-to-nix-packages."do-urlencode";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "quri" = quicklisp-to-nix-packages."quri";
           "smart-buffer" = quicklisp-to-nix-packages."smart-buffer";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "vom" = quicklisp-to-nix-packages."vom";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "woo" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."woo" or (x: {}))
       (import ./quicklisp-to-nix-output/woo.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "clack-socket" = quicklisp-to-nix-packages."clack-socket";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "lev" = quicklisp-to-nix-packages."lev";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "quri" = quicklisp-to-nix-packages."quri";
           "smart-buffer" = quicklisp-to-nix-packages."smart-buffer";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "swap-bytes" = quicklisp-to-nix-packages."swap-bytes";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
           "vom" = quicklisp-to-nix-packages."vom";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "usocket" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."usocket" or (x: {}))
       (import ./quicklisp-to-nix-output/usocket.nix {
         inherit fetchurl;
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "unix-opts" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."unix-opts" or (x: {}))
       (import ./quicklisp-to-nix-output/unix-opts.nix {
         inherit fetchurl;
       }));


  "uffi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uffi" or (x: {}))
       (import ./quicklisp-to-nix-output/uffi.nix {
         inherit fetchurl;
       }));


  "trivial-utf-8" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-utf-8" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-utf-8.nix {
         inherit fetchurl;
       }));


  "trivial-types" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-types" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-types.nix {
         inherit fetchurl;
       }));


  "trivial-mimes" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-mimes" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-mimes.nix {
         inherit fetchurl;
       }));


  "trivial-indent" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-indent" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-indent.nix {
         inherit fetchurl;
       }));


  "trivial-clipboard" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-clipboard" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-clipboard.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "trivial-backtrace" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-backtrace" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-backtrace.nix {
         inherit fetchurl;
       }));


  "trivia" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivia" or (x: {}))
       (import ./quicklisp-to-nix-output/trivia.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "swap-bytes" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."swap-bytes" or (x: {}))
       (import ./quicklisp-to-nix-output/swap-bytes.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "swank" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."swank" or (x: {}))
       (import ./quicklisp-to-nix-output/swank.nix {
         inherit fetchurl;
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


  "str" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."str" or (x: {}))
       (import ./quicklisp-to-nix-output/str.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
       }));


  "static-vectors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."static-vectors" or (x: {}))
       (import ./quicklisp-to-nix-output/static-vectors.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "sqlite" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."sqlite" or (x: {}))
       (import ./quicklisp-to-nix-output/sqlite.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "split-sequence" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."split-sequence" or (x: {}))
       (import ./quicklisp-to-nix-output/split-sequence.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
       }));


  "smart-buffer" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."smart-buffer" or (x: {}))
       (import ./quicklisp-to-nix-output/smart-buffer.nix {
         inherit fetchurl;
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "simple-date" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."simple-date" or (x: {}))
       (import ./quicklisp-to-nix-output/simple-date.nix {
         inherit fetchurl;
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "md5" = quicklisp-to-nix-packages."md5";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "serapeum" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."serapeum" or (x: {}))
       (import ./quicklisp-to-nix-output/serapeum.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fare-quasiquote" = quicklisp-to-nix-packages."fare-quasiquote";
           "fare-quasiquote-extras" = quicklisp-to-nix-packages."fare-quasiquote-extras";
           "fare-quasiquote-optima" = quicklisp-to-nix-packages."fare-quasiquote-optima";
           "fare-quasiquote-readtable" = quicklisp-to-nix-packages."fare-quasiquote-readtable";
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
           "global-vars" = quicklisp-to-nix-packages."global-vars";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "string-case" = quicklisp-to-nix-packages."string-case";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_quasiquote" = quicklisp-to-nix-packages."trivia_dot_quasiquote";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "trivial-file-size" = quicklisp-to-nix-packages."trivial-file-size";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-macroexpand-all" = quicklisp-to-nix-packages."trivial-macroexpand-all";
           "type-i" = quicklisp-to-nix-packages."type-i";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "salza2" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."salza2" or (x: {}))
       (import ./quicklisp-to-nix-output/salza2.nix {
         inherit fetchurl;
       }));


  "quri" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."quri" or (x: {}))
       (import ./quicklisp-to-nix-output/quri.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "query-fs" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."query-fs" or (x: {}))
       (import ./quicklisp-to-nix-output/query-fs.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-fuse" = quicklisp-to-nix-packages."cl-fuse";
           "cl-fuse-meta-fs" = quicklisp-to-nix-packages."cl-fuse-meta-fs";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "command-line-arguments" = quicklisp-to-nix-packages."command-line-arguments";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "pcall" = quicklisp-to-nix-packages."pcall";
           "pcall-queue" = quicklisp-to-nix-packages."pcall-queue";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
       }));


  "prove-asdf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."prove-asdf" or (x: {}))
       (import ./quicklisp-to-nix-output/prove-asdf.nix {
         inherit fetchurl;
       }));


  "prove" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."prove" or (x: {}))
       (import ./quicklisp-to-nix-output/prove.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "cl-ansi-text" = quicklisp-to-nix-packages."cl-ansi-text";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "proc-parse" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."proc-parse" or (x: {}))
       (import ./quicklisp-to-nix-output/proc-parse.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "plump" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."plump" or (x: {}))
       (import ./quicklisp-to-nix-output/plump.nix {
         inherit fetchurl;
           "array-utils" = quicklisp-to-nix-packages."array-utils";
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "pcall" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."pcall" or (x: {}))
       (import ./quicklisp-to-nix-output/pcall.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "pcall-queue" = quicklisp-to-nix-packages."pcall-queue";
       }));


  "parenscript" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parenscript" or (x: {}))
       (import ./quicklisp-to-nix-output/parenscript.nix {
         inherit fetchurl;
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "optima" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."optima" or (x: {}))
       (import ./quicklisp-to-nix-output/optima.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
       }));


  "nibbles" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."nibbles" or (x: {}))
       (import ./quicklisp-to-nix-output/nibbles.nix {
         inherit fetchurl;
           "rt" = quicklisp-to-nix-packages."rt";
       }));


  "mt19937" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."mt19937" or (x: {}))
       (import ./quicklisp-to-nix-output/mt19937.nix {
         inherit fetchurl;
       }));


  "mk-string-metrics" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."mk-string-metrics" or (x: {}))
       (import ./quicklisp-to-nix-output/mk-string-metrics.nix {
         inherit fetchurl;
       }));


  "misc-extensions" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."misc-extensions" or (x: {}))
       (import ./quicklisp-to-nix-output/misc-extensions.nix {
         inherit fetchurl;
       }));


  "marshal" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."marshal" or (x: {}))
       (import ./quicklisp-to-nix-output/marshal.nix {
         inherit fetchurl;
       }));


  "lquery" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lquery" or (x: {}))
       (import ./quicklisp-to-nix-output/lquery.nix {
         inherit fetchurl;
           "array-utils" = quicklisp-to-nix-packages."array-utils";
           "clss" = quicklisp-to-nix-packages."clss";
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "form-fiddle" = quicklisp-to-nix-packages."form-fiddle";
           "plump" = quicklisp-to-nix-packages."plump";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "lparallel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lparallel" or (x: {}))
       (import ./quicklisp-to-nix-output/lparallel.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "log4cl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."log4cl" or (x: {}))
       (import ./quicklisp-to-nix-output/log4cl.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "stefil" = quicklisp-to-nix-packages."stefil";
       }));


  "local-time" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."local-time" or (x: {}))
       (import ./quicklisp-to-nix-output/local-time.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "stefil" = quicklisp-to-nix-packages."stefil";
       }));


  "lisp-namespace" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lisp-namespace" or (x: {}))
       (import ./quicklisp-to-nix-output/lisp-namespace.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "lfarm-ssl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lfarm-ssl" or (x: {}))
       (import ./quicklisp-to-nix-output/lfarm-ssl.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-store" = quicklisp-to-nix-packages."cl-store";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "lfarm-common" = quicklisp-to-nix-packages."lfarm-common";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "lfarm-server" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lfarm-server" or (x: {}))
       (import ./quicklisp-to-nix-output/lfarm-server.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-store" = quicklisp-to-nix-packages."cl-store";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "lfarm-common" = quicklisp-to-nix-packages."lfarm-common";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "lfarm-client" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lfarm-client" or (x: {}))
       (import ./quicklisp-to-nix-output/lfarm-client.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-store" = quicklisp-to-nix-packages."cl-store";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "lfarm-common" = quicklisp-to-nix-packages."lfarm-common";
           "lparallel" = quicklisp-to-nix-packages."lparallel";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "lev" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lev" or (x: {}))
       (import ./quicklisp-to-nix-output/lev.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "let-plus" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."let-plus" or (x: {}))
       (import ./quicklisp-to-nix-output/let-plus.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "lift" = quicklisp-to-nix-packages."lift";
       }));


  "lack" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lack" or (x: {}))
       (import ./quicklisp-to-nix-output/lack.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "lack-component" = quicklisp-to-nix-packages."lack-component";
           "lack-util" = quicklisp-to-nix-packages."lack-util";
           "nibbles" = quicklisp-to-nix-packages."nibbles";
       }));


  "iterate" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iterate" or (x: {}))
       (import ./quicklisp-to-nix-output/iterate.nix {
         inherit fetchurl;
       }));


  "ironclad" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."ironclad" or (x: {}))
       (import ./quicklisp-to-nix-output/ironclad.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "nibbles" = quicklisp-to-nix-packages."nibbles";
           "rt" = quicklisp-to-nix-packages."rt";
       }));


  "iolib" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "idna" = quicklisp-to-nix-packages."idna";
           "iolib_dot_asdf" = quicklisp-to-nix-packages."iolib_dot_asdf";
           "iolib_dot_base" = quicklisp-to-nix-packages."iolib_dot_base";
           "iolib_dot_common-lisp" = quicklisp-to-nix-packages."iolib_dot_common-lisp";
           "iolib_dot_conf" = quicklisp-to-nix-packages."iolib_dot_conf";
           "iolib_dot_grovel" = quicklisp-to-nix-packages."iolib_dot_grovel";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swap-bytes" = quicklisp-to-nix-packages."swap-bytes";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "ieee-floats" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."ieee-floats" or (x: {}))
       (import ./quicklisp-to-nix-output/ieee-floats.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
       }));


  "idna" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."idna" or (x: {}))
       (import ./quicklisp-to-nix-output/idna.nix {
         inherit fetchurl;
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "hunchentoot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hunchentoot" or (x: {}))
       (import ./quicklisp-to-nix-output/hunchentoot.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-who" = quicklisp-to-nix-packages."cl-who";
           "drakma" = quicklisp-to-nix-packages."drakma";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "md5" = quicklisp-to-nix-packages."md5";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "hu_dot_dwim_dot_asdf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_asdf" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_asdf.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "http-body" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."http-body" or (x: {}))
       (import ./quicklisp-to-nix-output/http-body.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "jonathan" = quicklisp-to-nix-packages."jonathan";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "quri" = quicklisp-to-nix-packages."quri";
           "smart-buffer" = quicklisp-to-nix-packages."smart-buffer";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "fset" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fset" or (x: {}))
       (import ./quicklisp-to-nix-output/fset.nix {
         inherit fetchurl;
           "misc-extensions" = quicklisp-to-nix-packages."misc-extensions";
           "mt19937" = quicklisp-to-nix-packages."mt19937";
       }));


  "form-fiddle" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."form-fiddle" or (x: {}))
       (import ./quicklisp-to-nix-output/form-fiddle.nix {
         inherit fetchurl;
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "flexi-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."flexi-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/flexi-streams.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "fiveam" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fiveam" or (x: {}))
       (import ./quicklisp-to-nix-output/fiveam.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "net_dot_didierverna_dot_asdf-flv" = quicklisp-to-nix-packages."net_dot_didierverna_dot_asdf-flv";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
       }));


  "fast-io" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fast-io" or (x: {}))
       (import ./quicklisp-to-nix-output/fast-io.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "fast-http" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fast-http" or (x: {}))
       (import ./quicklisp-to-nix-output/fast-http.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "smart-buffer" = quicklisp-to-nix-packages."smart-buffer";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "external-program" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."external-program" or (x: {}))
       (import ./quicklisp-to-nix-output/external-program.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "esrap-peg" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."esrap-peg" or (x: {}))
       (import ./quicklisp-to-nix-output/esrap-peg.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-unification" = quicklisp-to-nix-packages."cl-unification";
           "esrap" = quicklisp-to-nix-packages."esrap";
           "iterate" = quicklisp-to-nix-packages."iterate";
       }));


  "esrap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."esrap" or (x: {}))
       (import ./quicklisp-to-nix-output/esrap.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
       }));


  "drakma" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."drakma" or (x: {}))
       (import ./quicklisp-to-nix-output/drakma.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "chipz" = quicklisp-to-nix-packages."chipz";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "puri" = quicklisp-to-nix-packages."puri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "documentation-utils" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."documentation-utils" or (x: {}))
       (import ./quicklisp-to-nix-output/documentation-utils.nix {
         inherit fetchurl;
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "dexador" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dexador" or (x: {}))
       (import ./quicklisp-to-nix-output/dexador.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "chipz" = quicklisp-to-nix-packages."chipz";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-cookie" = quicklisp-to-nix-packages."cl-cookie";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-reexport" = quicklisp-to-nix-packages."cl-reexport";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "quri" = quicklisp-to-nix-packages."quri";
           "smart-buffer" = quicklisp-to-nix-packages."smart-buffer";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-mimes" = quicklisp-to-nix-packages."trivial-mimes";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "dbus" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbus" or (x: {}))
       (import ./quicklisp-to-nix-output/dbus.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "asdf-package-system" = quicklisp-to-nix-packages."asdf-package-system";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-xmlspam" = quicklisp-to-nix-packages."cl-xmlspam";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "ieee-floats" = quicklisp-to-nix-packages."ieee-floats";
           "iolib" = quicklisp-to-nix-packages."iolib";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "dbd-sqlite3" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbd-sqlite3" or (x: {}))
       (import ./quicklisp-to-nix-output/dbd-sqlite3.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "sqlite" = quicklisp-to-nix-packages."sqlite";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "dbd-postgres" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbd-postgres" or (x: {}))
       (import ./quicklisp-to-nix-output/dbd-postgres.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "md5" = quicklisp-to-nix-packages."md5";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "dbd-mysql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbd-mysql" or (x: {}))
       (import ./quicklisp-to-nix-output/dbd-mysql.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-mysql" = quicklisp-to-nix-packages."cl-mysql";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cxml" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "puri" = quicklisp-to-nix-packages."puri";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "css-selectors-stp" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."css-selectors-stp" or (x: {}))
       (import ./quicklisp-to-nix-output/css-selectors-stp.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "buildnode" = quicklisp-to-nix-packages."buildnode";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "closure-html" = quicklisp-to-nix-packages."closure-html";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "css-selectors" = quicklisp-to-nix-packages."css-selectors";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "cxml-stp" = quicklisp-to-nix-packages."cxml-stp";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
           "puri" = quicklisp-to-nix-packages."puri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swank" = quicklisp-to-nix-packages."swank";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "xpath" = quicklisp-to-nix-packages."xpath";
           "yacc" = quicklisp-to-nix-packages."yacc";
       }));


  "css-selectors-simple-tree" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."css-selectors-simple-tree" or (x: {}))
       (import ./quicklisp-to-nix-output/css-selectors-simple-tree.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "buildnode" = quicklisp-to-nix-packages."buildnode";
           "cl-html5-parser" = quicklisp-to-nix-packages."cl-html5-parser";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "closure-html" = quicklisp-to-nix-packages."closure-html";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "css-selectors" = quicklisp-to-nix-packages."css-selectors";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "puri" = quicklisp-to-nix-packages."puri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "string-case" = quicklisp-to-nix-packages."string-case";
           "swank" = quicklisp-to-nix-packages."swank";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "yacc" = quicklisp-to-nix-packages."yacc";
       }));


  "css-selectors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."css-selectors" or (x: {}))
       (import ./quicklisp-to-nix-output/css-selectors.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "buildnode" = quicklisp-to-nix-packages."buildnode";
           "buildnode-xhtml" = quicklisp-to-nix-packages."buildnode-xhtml";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "closure-html" = quicklisp-to-nix-packages."closure-html";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-unit2" = quicklisp-to-nix-packages."lisp-unit2";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "puri" = quicklisp-to-nix-packages."puri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swank" = quicklisp-to-nix-packages."swank";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "yacc" = quicklisp-to-nix-packages."yacc";
       }));


  "css-lite" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."css-lite" or (x: {}))
       (import ./quicklisp-to-nix-output/css-lite.nix {
         inherit fetchurl;
       }));


  "command-line-arguments" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."command-line-arguments" or (x: {}))
       (import ./quicklisp-to-nix-output/command-line-arguments.nix {
         inherit fetchurl;
       }));


  "clx-truetype" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clx-truetype" or (x: {}))
       (import ./quicklisp-to-nix-output/clx-truetype.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-aa" = quicklisp-to-nix-packages."cl-aa";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-paths" = quicklisp-to-nix-packages."cl-paths";
           "cl-paths-ttf" = quicklisp-to-nix-packages."cl-paths-ttf";
           "cl-store" = quicklisp-to-nix-packages."cl-store";
           "cl-vectors" = quicklisp-to-nix-packages."cl-vectors";
           "clx" = quicklisp-to-nix-packages."clx";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "zpb-ttf" = quicklisp-to-nix-packages."zpb-ttf";
       }));


  "clx" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clx" or (x: {}))
       (import ./quicklisp-to-nix-output/clx.nix {
         inherit fetchurl;
           "fiasco" = quicklisp-to-nix-packages."fiasco";
       }));


  "clss" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clss" or (x: {}))
       (import ./quicklisp-to-nix-output/clss.nix {
         inherit fetchurl;
           "array-utils" = quicklisp-to-nix-packages."array-utils";
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "plump" = quicklisp-to-nix-packages."plump";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "clsql-sqlite3" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clsql-sqlite3" or (x: {}))
       (import ./quicklisp-to-nix-output/clsql-sqlite3.nix {
         inherit fetchurl;
           "clsql" = quicklisp-to-nix-packages."clsql";
           "clsql-uffi" = quicklisp-to-nix-packages."clsql-uffi";
           "uffi" = quicklisp-to-nix-packages."uffi";
       }));


  "clsql-postgresql-socket" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clsql-postgresql-socket" or (x: {}))
       (import ./quicklisp-to-nix-output/clsql-postgresql-socket.nix {
         inherit fetchurl;
           "clsql" = quicklisp-to-nix-packages."clsql";
           "md5" = quicklisp-to-nix-packages."md5";
           "uffi" = quicklisp-to-nix-packages."uffi";
       }));


  "clsql-postgresql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clsql-postgresql" or (x: {}))
       (import ./quicklisp-to-nix-output/clsql-postgresql.nix {
         inherit fetchurl;
           "clsql" = quicklisp-to-nix-packages."clsql";
           "clsql-uffi" = quicklisp-to-nix-packages."clsql-uffi";
           "uffi" = quicklisp-to-nix-packages."uffi";
       }));


  "clsql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clsql" or (x: {}))
       (import ./quicklisp-to-nix-output/clsql.nix {
         inherit fetchurl;
           "uffi" = quicklisp-to-nix-packages."uffi";
       }));


  "closure-html" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."closure-html" or (x: {}))
       (import ./quicklisp-to-nix-output/closure-html.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "closer-mop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."closer-mop" or (x: {}))
       (import ./quicklisp-to-nix-output/closer-mop.nix {
         inherit fetchurl;
       }));


  "clack-v1-compat" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack-v1-compat" or (x: {}))
       (import ./quicklisp-to-nix-output/clack-v1-compat.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "chipz" = quicklisp-to-nix-packages."chipz";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "circular-streams" = quicklisp-to-nix-packages."circular-streams";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-ansi-text" = quicklisp-to-nix-packages."cl-ansi-text";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "cl-cookie" = quicklisp-to-nix-packages."cl-cookie";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-reexport" = quicklisp-to-nix-packages."cl-reexport";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "clack" = quicklisp-to-nix-packages."clack";
           "clack-handler-hunchentoot" = quicklisp-to-nix-packages."clack-handler-hunchentoot";
           "clack-socket" = quicklisp-to-nix-packages."clack-socket";
           "clack-test" = quicklisp-to-nix-packages."clack-test";
           "dexador" = quicklisp-to-nix-packages."dexador";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "http-body" = quicklisp-to-nix-packages."http-body";
           "hunchentoot" = quicklisp-to-nix-packages."hunchentoot";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "jonathan" = quicklisp-to-nix-packages."jonathan";
           "lack" = quicklisp-to-nix-packages."lack";
           "lack-component" = quicklisp-to-nix-packages."lack-component";
           "lack-middleware-backtrace" = quicklisp-to-nix-packages."lack-middleware-backtrace";
           "lack-util" = quicklisp-to-nix-packages."lack-util";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "marshal" = quicklisp-to-nix-packages."marshal";
           "md5" = quicklisp-to-nix-packages."md5";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "nibbles" = quicklisp-to-nix-packages."nibbles";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "prove" = quicklisp-to-nix-packages."prove";
           "quri" = quicklisp-to-nix-packages."quri";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "smart-buffer" = quicklisp-to-nix-packages."smart-buffer";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-mimes" = quicklisp-to-nix-packages."trivial-mimes";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "clack" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack" or (x: {}))
       (import ./quicklisp-to-nix-output/clack.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "lack" = quicklisp-to-nix-packages."lack";
           "lack-component" = quicklisp-to-nix-packages."lack-component";
           "lack-middleware-backtrace" = quicklisp-to-nix-packages."lack-middleware-backtrace";
           "lack-util" = quicklisp-to-nix-packages."lack-util";
           "nibbles" = quicklisp-to-nix-packages."nibbles";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "cl-who" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-who" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-who.nix {
         inherit fetchurl;
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
       }));


  "cl-vectors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-vectors" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-vectors.nix {
         inherit fetchurl;
           "cl-aa" = quicklisp-to-nix-packages."cl-aa";
           "cl-paths" = quicklisp-to-nix-packages."cl-paths";
       }));


  "cl-utilities" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-utilities" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-utilities.nix {
         inherit fetchurl;
       }));


  "cl-unification" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-unification" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-unification.nix {
         inherit fetchurl;
       }));


  "cl-unicode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-unicode" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-unicode.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
       }));


  "cl-typesetting" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-typesetting" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-typesetting.nix {
         inherit fetchurl;
           "cl-pdf" = quicklisp-to-nix-packages."cl-pdf";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "zpb-ttf" = quicklisp-to-nix-packages."zpb-ttf";
       }));


  "cl-test-more" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-test-more" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-test-more.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "cl-ansi-text" = quicklisp-to-nix-packages."cl-ansi-text";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "prove" = quicklisp-to-nix-packages."prove";
       }));


  "cl-syntax-markup" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax-markup" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax-markup.nix {
         inherit fetchurl;
           "cl-markup" = quicklisp-to-nix-packages."cl-markup";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cl-syntax-anonfun" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax-anonfun" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax-anonfun.nix {
         inherit fetchurl;
           "cl-anonfun" = quicklisp-to-nix-packages."cl-anonfun";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cl-syntax-annot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax-annot" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax-annot.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cl-smtp" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-smtp" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-smtp.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "cl-reexport" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-reexport" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-reexport.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "cl-protobufs" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-protobufs" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-protobufs.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-ppcre-unicode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ppcre-unicode" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ppcre-unicode.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-ppcre-test" = quicklisp-to-nix-packages."cl-ppcre-test";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
       }));


  "cl-ppcre-template" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ppcre-template" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ppcre-template.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unification" = quicklisp-to-nix-packages."cl-unification";
       }));


  "cl-ppcre" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ppcre" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ppcre.nix {
         inherit fetchurl;
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
       }));


  "cl-pdf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-pdf" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-pdf.nix {
         inherit fetchurl;
           "iterate" = quicklisp-to-nix-packages."iterate";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "zpb-ttf" = quicklisp-to-nix-packages."zpb-ttf";
       }));


  "cl-mysql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-mysql" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-mysql.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "cl-libuv" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-libuv" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-libuv.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "cl-l10n" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-l10n" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-l10n.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-l10n-cldr" = quicklisp-to-nix-packages."cl-l10n-cldr";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "hu_dot_dwim_dot_stefil" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
           "puri" = quicklisp-to-nix-packages."puri";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cl-json" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-json" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-json.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
       }));


  "cl-jpeg" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-jpeg" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-jpeg.nix {
         inherit fetchurl;
       }));


  "cl-html5-parser" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-html5-parser" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-html5-parser.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "string-case" = quicklisp-to-nix-packages."string-case";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cl-html-parse" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-html-parse" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-html-parse.nix {
         inherit fetchurl;
       }));


  "cl-hooks" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-hooks" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-hooks.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-fuse-meta-fs" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fuse-meta-fs" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fuse-meta-fs.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-fuse" = quicklisp-to-nix-packages."cl-fuse";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "pcall" = quicklisp-to-nix-packages."pcall";
           "pcall-queue" = quicklisp-to-nix-packages."pcall-queue";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
       }));


  "cl-fuse" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fuse" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fuse.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
       }));


  "cl-emb" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-emb" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-emb.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
       }));


  "cl-dbi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-dbi" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-dbi.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cl-csv" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-csv" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-csv.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-unit2" = quicklisp-to-nix-packages."lisp-unit2";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "cl-css" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-css" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-css.nix {
         inherit fetchurl;
       }));


  "cl-cookie" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cookie" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cookie.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "quri" = quicklisp-to-nix-packages."quri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "cl-colors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-colors" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-colors.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "lift" = quicklisp-to-nix-packages."lift";
       }));


  "cl-cli" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cli" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cli.nix {
         inherit fetchurl;
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "cl-base64" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-base64" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-base64.nix {
         inherit fetchurl;
           "kmrcl" = quicklisp-to-nix-packages."kmrcl";
           "ptester" = quicklisp-to-nix-packages."ptester";
       }));


  "cl-async-ssl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async-ssl" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async-ssl.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-async" = quicklisp-to-nix-packages."cl-async";
           "cl-async-base" = quicklisp-to-nix-packages."cl-async-base";
           "cl-async-util" = quicklisp-to-nix-packages."cl-async-util";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "vom" = quicklisp-to-nix-packages."vom";
       }));


  "cl-async-repl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async-repl" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async-repl.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-async" = quicklisp-to-nix-packages."cl-async";
           "cl-async-base" = quicklisp-to-nix-packages."cl-async-base";
           "cl-async-util" = quicklisp-to-nix-packages."cl-async-util";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "vom" = quicklisp-to-nix-packages."vom";
       }));


  "cl-async-base" = quicklisp-to-nix-packages."cl-async";


  "cl-async" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "vom" = quicklisp-to-nix-packages."vom";
       }));


  "cl-ansi-text" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ansi-text" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ansi-text.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
       }));


  "cl_plus_ssl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl_plus_ssl" or (x: {}))
       (import ./quicklisp-to-nix-output/cl_plus_ssl.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "circular-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."circular-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/circular-streams.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "chipz" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chipz" or (x: {}))
       (import ./quicklisp-to-nix-output/chipz.nix {
         inherit fetchurl;
       }));


  "cffi-grovel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi-grovel" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi-grovel.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "cffi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-json" = quicklisp-to-nix-packages."cl-json";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "caveman" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."caveman" or (x: {}))
       (import ./quicklisp-to-nix-output/caveman.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "chipz" = quicklisp-to-nix-packages."chipz";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "circular-streams" = quicklisp-to-nix-packages."circular-streams";
           "cl_plus_ssl" = quicklisp-to-nix-packages."cl_plus_ssl";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-ansi-text" = quicklisp-to-nix-packages."cl-ansi-text";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "cl-cookie" = quicklisp-to-nix-packages."cl-cookie";
           "cl-emb" = quicklisp-to-nix-packages."cl-emb";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-project" = quicklisp-to-nix-packages."cl-project";
           "cl-reexport" = quicklisp-to-nix-packages."cl-reexport";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "clack" = quicklisp-to-nix-packages."clack";
           "clack-handler-hunchentoot" = quicklisp-to-nix-packages."clack-handler-hunchentoot";
           "clack-socket" = quicklisp-to-nix-packages."clack-socket";
           "clack-test" = quicklisp-to-nix-packages."clack-test";
           "clack-v1-compat" = quicklisp-to-nix-packages."clack-v1-compat";
           "dexador" = quicklisp-to-nix-packages."dexador";
           "do-urlencode" = quicklisp-to-nix-packages."do-urlencode";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "http-body" = quicklisp-to-nix-packages."http-body";
           "hunchentoot" = quicklisp-to-nix-packages."hunchentoot";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "jonathan" = quicklisp-to-nix-packages."jonathan";
           "lack" = quicklisp-to-nix-packages."lack";
           "lack-component" = quicklisp-to-nix-packages."lack-component";
           "lack-middleware-backtrace" = quicklisp-to-nix-packages."lack-middleware-backtrace";
           "lack-util" = quicklisp-to-nix-packages."lack-util";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "map-set" = quicklisp-to-nix-packages."map-set";
           "marshal" = quicklisp-to-nix-packages."marshal";
           "md5" = quicklisp-to-nix-packages."md5";
           "myway" = quicklisp-to-nix-packages."myway";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "nibbles" = quicklisp-to-nix-packages."nibbles";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "prove" = quicklisp-to-nix-packages."prove";
           "quri" = quicklisp-to-nix-packages."quri";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "smart-buffer" = quicklisp-to-nix-packages."smart-buffer";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-mimes" = quicklisp-to-nix-packages."trivial-mimes";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "bordeaux-threads" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."bordeaux-threads" or (x: {}))
       (import ./quicklisp-to-nix-output/bordeaux-threads.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
       }));


  "blackbird" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."blackbird" or (x: {}))
       (import ./quicklisp-to-nix-output/blackbird.nix {
         inherit fetchurl;
           "vom" = quicklisp-to-nix-packages."vom";
       }));


  "babel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."babel" or (x: {}))
       (import ./quicklisp-to-nix-output/babel.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "asdf-system-connections" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."asdf-system-connections" or (x: {}))
       (import ./quicklisp-to-nix-output/asdf-system-connections.nix {
         inherit fetchurl;
       }));


  "array-utils" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."array-utils" or (x: {}))
       (import ./quicklisp-to-nix-output/array-utils.nix {
         inherit fetchurl;
       }));


  "alexandria" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."alexandria" or (x: {}))
       (import ./quicklisp-to-nix-output/alexandria.nix {
         inherit fetchurl;
       }));


  "_3bmd" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."_3bmd" or (x: {}))
       (import ./quicklisp-to-nix-output/_3bmd.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "esrap" = quicklisp-to-nix-packages."esrap";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "cl-prevalence" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-prevalence" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-prevalence.nix {
         inherit fetchurl;
           "s-sysdeps" = quicklisp-to-nix-packages."s-sysdeps";
           "s-xml" = quicklisp-to-nix-packages."s-xml";
       }));


};
in
   quicklisp-to-nix-packages
