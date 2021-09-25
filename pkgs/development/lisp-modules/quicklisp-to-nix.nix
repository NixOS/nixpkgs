{stdenv, lib, fetchurl, pkgs, clwrapper}:
let quicklisp-to-nix-packages = rec {
  inherit stdenv lib fetchurl clwrapper pkgs quicklisp-to-nix-packages;

  callPackage = pkgs.lib.callPackageWith quicklisp-to-nix-packages;
  buildLispPackage = callPackage ./define-package.nix;
  qlOverrides = callPackage ./quicklisp-to-nix-overrides.nix {};

  "html-encode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."html-encode" or (x: {}))
       (import ./quicklisp-to-nix-output/html-encode.nix {
         inherit fetchurl;
       }));


  "hu_dot_dwim_dot_stefil_plus_swank" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_stefil_plus_swank" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_stefil_plus_swank.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
           "hu_dot_dwim_dot_stefil" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil";
           "swank" = quicklisp-to-nix-packages."swank";
       }));


  "hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
           "hu_dot_dwim_dot_def" = quicklisp-to-nix-packages."hu_dot_dwim_dot_def";
           "hu_dot_dwim_dot_stefil" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
       }));


  "hu_dot_dwim_dot_def_plus_swank" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_def_plus_swank" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_def_plus_swank.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
           "hu_dot_dwim_dot_def" = quicklisp-to-nix-packages."hu_dot_dwim_dot_def";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
           "swank" = quicklisp-to-nix-packages."swank";
       }));


  "hu_dot_dwim_dot_def" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_def" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_def.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
       }));


  "hu_dot_dwim_dot_common-lisp" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_common-lisp" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_common-lisp.nix {
         inherit fetchurl;
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
       }));


  "rove" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."rove" or (x: {}))
       (import ./quicklisp-to-nix-output/rove.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "dissect" = quicklisp-to-nix-packages."dissect";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "dbi-test" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbi-test" or (x: {}))
       (import ./quicklisp-to-nix-output/dbi-test.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "dissect" = quicklisp-to-nix-packages."dissect";
           "rove" = quicklisp-to-nix-packages."rove";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
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


  "clack-socket" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack-socket" or (x: {}))
       (import ./quicklisp-to-nix-output/clack-socket.nix {
         inherit fetchurl;
       }));


  "vas-string-metrics" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."vas-string-metrics" or (x: {}))
       (import ./quicklisp-to-nix-output/vas-string-metrics.nix {
         inherit fetchurl;
       }));


  "parse-float" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parse-float" or (x: {}))
       (import ./quicklisp-to-nix-output/parse-float.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "lisp-unit" = quicklisp-to-nix-packages."lisp-unit";
       }));


  "glsl-symbols" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."glsl-symbols" or (x: {}))
       (import ./quicklisp-to-nix-output/glsl-symbols.nix {
         inherit fetchurl;
       }));


  "glsl-spec" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."glsl-spec" or (x: {}))
       (import ./quicklisp-to-nix-output/glsl-spec.nix {
         inherit fetchurl;
       }));


  "glsl-docs" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."glsl-docs" or (x: {}))
       (import ./quicklisp-to-nix-output/glsl-docs.nix {
         inherit fetchurl;
           "glsl-symbols" = quicklisp-to-nix-packages."glsl-symbols";
       }));


  "fn" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fn" or (x: {}))
       (import ./quicklisp-to-nix-output/fn.nix {
         inherit fetchurl;
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "simple-tasks" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."simple-tasks" or (x: {}))
       (import ./quicklisp-to-nix-output/simple-tasks.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "array-utils" = quicklisp-to-nix-packages."array-utils";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "dissect" = quicklisp-to-nix-packages."dissect";
       }));


  "dissect" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dissect" or (x: {}))
       (import ./quicklisp-to-nix-output/dissect.nix {
         inherit fetchurl;
       }));


  "lisp-unit" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lisp-unit" or (x: {}))
       (import ./quicklisp-to-nix-output/lisp-unit.nix {
         inherit fetchurl;
       }));


  "cl-fuzz" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fuzz" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fuzz.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "cl-change-case" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-change-case" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-change-case.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-ppcre-unicode" = quicklisp-to-nix-packages."cl-ppcre-unicode";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
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


  "simple-date_slash_postgres-glue" = quicklisp-to-nix-packages."simple-date";


  "s-sql_slash_tests" = quicklisp-to-nix-packages."s-sql";


  "s-sql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."s-sql" or (x: {}))
       (import ./quicklisp-to-nix-output/s-sql.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
           "cl-postgres_slash_tests" = quicklisp-to-nix-packages."cl-postgres_slash_tests";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "global-vars" = quicklisp-to-nix-packages."global-vars";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "md5" = quicklisp-to-nix-packages."md5";
           "postmodern" = quicklisp-to-nix-packages."postmodern";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "uax-15" = quicklisp-to-nix-packages."uax-15";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "cl-postgres_slash_tests" = quicklisp-to-nix-packages."cl-postgres";


  "cl-postgres_plus_local-time" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-postgres_plus_local-time" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-postgres_plus_local-time.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "md5" = quicklisp-to-nix-packages."md5";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "uax-15" = quicklisp-to-nix-packages."uax-15";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "parseq" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parseq" or (x: {}))
       (import ./quicklisp-to-nix-output/parseq.nix {
         inherit fetchurl;
       }));


  "colorize" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."colorize" or (x: {}))
       (import ./quicklisp-to-nix-output/colorize.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "html-encode" = quicklisp-to-nix-packages."html-encode";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "_3bmd-ext-code-blocks" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."_3bmd-ext-code-blocks" or (x: {}))
       (import ./quicklisp-to-nix-output/_3bmd-ext-code-blocks.nix {
         inherit fetchurl;
           "_3bmd" = quicklisp-to-nix-packages."_3bmd";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "colorize" = quicklisp-to-nix-packages."colorize";
           "esrap" = quicklisp-to-nix-packages."esrap";
           "html-encode" = quicklisp-to-nix-packages."html-encode";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-with-current-source-form" = quicklisp-to-nix-packages."trivial-with-current-source-form";
       }));


  "cl-num-utils" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-num-utils" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-num-utils.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "array-operations" = quicklisp-to-nix-packages."array-operations";
           "cl-slice" = quicklisp-to-nix-packages."cl-slice";
           "clunit" = quicklisp-to-nix-packages."clunit";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
       }));


  "quasiquote-2_dot_0" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."quasiquote-2_dot_0" or (x: {}))
       (import ./quicklisp-to-nix-output/quasiquote-2_dot_0.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "iterate" = quicklisp-to-nix-packages."iterate";
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
           "fare-quasiquote-readtable" = quicklisp-to-nix-packages."fare-quasiquote-readtable";
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_quasiquote" = quicklisp-to-nix-packages."trivia_dot_quasiquote";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
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
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_quasiquote" = quicklisp-to-nix-packages."trivia_dot_quasiquote";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
       }));


  "hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def_plus_swank" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def_plus_swank" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def_plus_swank.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
           "hu_dot_dwim_dot_def" = quicklisp-to-nix-packages."hu_dot_dwim_dot_def";
           "hu_dot_dwim_dot_def_plus_swank" = quicklisp-to-nix-packages."hu_dot_dwim_dot_def_plus_swank";
           "hu_dot_dwim_dot_stefil" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil";
           "hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def";
           "hu_dot_dwim_dot_stefil_plus_swank" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil_plus_swank";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
           "swank" = quicklisp-to-nix-packages."swank";
       }));


  "hu_dot_dwim_dot_common" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_common" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_common.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
           "hu_dot_dwim_dot_common-lisp" = quicklisp-to-nix-packages."hu_dot_dwim_dot_common-lisp";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
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


  "static-dispatch" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."static-dispatch" or (x: {}))
       (import ./quicklisp-to-nix-output/static-dispatch.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
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


  "generic-cl_dot_set" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_set" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_set.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-custom-hash-table" = quicklisp-to-nix-packages."cl-custom-hash-table";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_arithmetic" = quicklisp-to-nix-packages."generic-cl_dot_arithmetic";
           "generic-cl_dot_collector" = quicklisp-to-nix-packages."generic-cl_dot_collector";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_container" = quicklisp-to-nix-packages."generic-cl_dot_container";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "generic-cl_dot_iterator" = quicklisp-to-nix-packages."generic-cl_dot_iterator";
           "generic-cl_dot_map" = quicklisp-to-nix-packages."generic-cl_dot_map";
           "generic-cl_dot_object" = quicklisp-to-nix-packages."generic-cl_dot_object";
           "generic-cl_dot_sequence" = quicklisp-to-nix-packages."generic-cl_dot_sequence";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_sequence" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_sequence" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_sequence.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-custom-hash-table" = quicklisp-to-nix-packages."cl-custom-hash-table";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_collector" = quicklisp-to-nix-packages."generic-cl_dot_collector";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_container" = quicklisp-to-nix-packages."generic-cl_dot_container";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "generic-cl_dot_iterator" = quicklisp-to-nix-packages."generic-cl_dot_iterator";
           "generic-cl_dot_map" = quicklisp-to-nix-packages."generic-cl_dot_map";
           "generic-cl_dot_object" = quicklisp-to-nix-packages."generic-cl_dot_object";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_object" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_object" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_object.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_math" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_math" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_math.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_arithmetic" = quicklisp-to-nix-packages."generic-cl_dot_arithmetic";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_map" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_map" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_map.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-custom-hash-table" = quicklisp-to-nix-packages."cl-custom-hash-table";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_collector" = quicklisp-to-nix-packages."generic-cl_dot_collector";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_container" = quicklisp-to-nix-packages."generic-cl_dot_container";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "generic-cl_dot_iterator" = quicklisp-to-nix-packages."generic-cl_dot_iterator";
           "generic-cl_dot_object" = quicklisp-to-nix-packages."generic-cl_dot_object";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_lazy-seq" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_lazy-seq" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_lazy-seq.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-custom-hash-table" = quicklisp-to-nix-packages."cl-custom-hash-table";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_collector" = quicklisp-to-nix-packages."generic-cl_dot_collector";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_container" = quicklisp-to-nix-packages."generic-cl_dot_container";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "generic-cl_dot_iterator" = quicklisp-to-nix-packages."generic-cl_dot_iterator";
           "generic-cl_dot_map" = quicklisp-to-nix-packages."generic-cl_dot_map";
           "generic-cl_dot_object" = quicklisp-to-nix-packages."generic-cl_dot_object";
           "generic-cl_dot_sequence" = quicklisp-to-nix-packages."generic-cl_dot_sequence";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_iterator" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_iterator" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_iterator.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_container" = quicklisp-to-nix-packages."generic-cl_dot_container";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "generic-cl_dot_object" = quicklisp-to-nix-packages."generic-cl_dot_object";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_internal" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_internal" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_internal.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_container" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_container" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_container.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "generic-cl_dot_object" = quicklisp-to-nix-packages."generic-cl_dot_object";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_comparison" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_comparison" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_comparison.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_collector" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_collector" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_collector.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_container" = quicklisp-to-nix-packages."generic-cl_dot_container";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "generic-cl_dot_iterator" = quicklisp-to-nix-packages."generic-cl_dot_iterator";
           "generic-cl_dot_object" = quicklisp-to-nix-packages."generic-cl_dot_object";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "generic-cl_dot_arithmetic" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl_dot_arithmetic" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl_dot_arithmetic.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "cl-form-types" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-form-types" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-form-types.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
       }));


  "cl-environments" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-environments" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-environments.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
       }));


  "arrows" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."arrows" or (x: {}))
       (import ./quicklisp-to-nix-output/arrows.nix {
         inherit fetchurl;
           "hu_dot_dwim_dot_stefil" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil";
       }));


  "agutil" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."agutil" or (x: {}))
       (import ./quicklisp-to-nix-output/agutil.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "optima" = quicklisp-to-nix-packages."optima";
       }));


  "net_dot_didierverna_dot_asdf-flv" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."net_dot_didierverna_dot_asdf-flv" or (x: {}))
       (import ./quicklisp-to-nix-output/net_dot_didierverna_dot_asdf-flv.nix {
         inherit fetchurl;
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


  "uax-15" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uax-15" or (x: {}))
       (import ./quicklisp-to-nix-output/uax-15.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "parachute" = quicklisp-to-nix-packages."parachute";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "cl-postgres" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-postgres" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-postgres.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "md5" = quicklisp-to-nix-packages."md5";
           "simple-date" = quicklisp-to-nix-packages."simple-date";
           "simple-date_slash_postgres-glue" = quicklisp-to-nix-packages."simple-date_slash_postgres-glue";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "uax-15" = quicklisp-to-nix-packages."uax-15";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "xpath_slash_test" = quicklisp-to-nix-packages."xpath";


  "cxml_slash_test" = quicklisp-to-nix-packages."cxml";


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


  "yacc" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."yacc" or (x: {}))
       (import ./quicklisp-to-nix-output/yacc.nix {
         inherit fetchurl;
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


  "fiasco" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fiasco" or (x: {}))
       (import ./quicklisp-to-nix-output/fiasco.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "clump-binary-tree" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clump-binary-tree" or (x: {}))
       (import ./quicklisp-to-nix-output/clump-binary-tree.nix {
         inherit fetchurl;
           "acclimation" = quicklisp-to-nix-packages."acclimation";
       }));


  "clump-2-3-tree" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clump-2-3-tree" or (x: {}))
       (import ./quicklisp-to-nix-output/clump-2-3-tree.nix {
         inherit fetchurl;
           "acclimation" = quicklisp-to-nix-packages."acclimation";
       }));


  "clsql-uffi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clsql-uffi" or (x: {}))
       (import ./quicklisp-to-nix-output/clsql-uffi.nix {
         inherit fetchurl;
           "clsql" = quicklisp-to-nix-packages."clsql";
           "uffi" = quicklisp-to-nix-packages."uffi";
       }));


  "lack-util" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lack-util" or (x: {}))
       (import ./quicklisp-to-nix-output/lack-util.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
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


  "cl-aa" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-aa" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-aa.nix {
         inherit fetchurl;
       }));


  "global-vars" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."global-vars" or (x: {}))
       (import ./quicklisp-to-nix-output/global-vars.nix {
         inherit fetchurl;
       }));


  "cl-anonfun" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-anonfun" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-anonfun.nix {
         inherit fetchurl;
       }));


  "asdf-package-system" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."asdf-package-system" or (x: {}))
       (import ./quicklisp-to-nix-output/asdf-package-system.nix {
         inherit fetchurl;
       }));


  "clunit" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clunit" or (x: {}))
       (import ./quicklisp-to-nix-output/clunit.nix {
         inherit fetchurl;
       }));


  "zpng" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."zpng" or (x: {}))
       (import ./quicklisp-to-nix-output/zpng.nix {
         inherit fetchurl;
           "salza2" = quicklisp-to-nix-packages."salza2";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "asdf" = quicklisp-to-nix-packages."uiop";


  "usocket-server" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."usocket-server" or (x: {}))
       (import ./quicklisp-to-nix-output/usocket-server.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "usocket" = quicklisp-to-nix-packages."usocket";
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
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "usocket-server" = quicklisp-to-nix-packages."usocket-server";
       }));


  "cl-ppcre-test" = quicklisp-to-nix-packages."cl-ppcre";


  "zpb-ttf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."zpb-ttf" or (x: {}))
       (import ./quicklisp-to-nix-output/zpb-ttf.nix {
         inherit fetchurl;
       }));


  "cl-paths" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-paths" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-paths.nix {
         inherit fetchurl;
       }));


  "hu_dot_dwim_dot_stefil" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_stefil" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_stefil.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
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


  "cl-difflib" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-difflib" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-difflib.nix {
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


  "unit-test" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."unit-test" or (x: {}))
       (import ./quicklisp-to-nix-output/unit-test.nix {
         inherit fetchurl;
       }));


  "dbi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbi" or (x: {}))
       (import ./quicklisp-to-nix-output/dbi.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-mysql" = quicklisp-to-nix-packages."cl-mysql";
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbd-mysql" = quicklisp-to-nix-packages."dbd-mysql";
           "dbd-postgres" = quicklisp-to-nix-packages."dbd-postgres";
           "dbd-sqlite3" = quicklisp-to-nix-packages."dbd-sqlite3";
           "dbi-test" = quicklisp-to-nix-packages."dbi-test";
           "rove" = quicklisp-to-nix-packages."rove";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "sqlite" = quicklisp-to-nix-packages."sqlite";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cl-cffi-gtk-pango" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cffi-gtk-pango" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cffi-gtk-pango.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-cffi-gtk-cairo" = quicklisp-to-nix-packages."cl-cffi-gtk-cairo";
           "cl-cffi-gtk-glib" = quicklisp-to-nix-packages."cl-cffi-gtk-glib";
           "cl-cffi-gtk-gobject" = quicklisp-to-nix-packages."cl-cffi-gtk-gobject";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-cffi-gtk-gobject" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cffi-gtk-gobject" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cffi-gtk-gobject.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-cffi-gtk-glib" = quicklisp-to-nix-packages."cl-cffi-gtk-glib";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-cffi-gtk-glib" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cffi-gtk-glib" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cffi-gtk-glib.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "cl-cffi-gtk-gio" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cffi-gtk-gio" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cffi-gtk-gio.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-cffi-gtk-glib" = quicklisp-to-nix-packages."cl-cffi-gtk-glib";
           "cl-cffi-gtk-gobject" = quicklisp-to-nix-packages."cl-cffi-gtk-gobject";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-cffi-gtk-gdk-pixbuf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cffi-gtk-gdk-pixbuf" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cffi-gtk-gdk-pixbuf.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-cffi-gtk-glib" = quicklisp-to-nix-packages."cl-cffi-gtk-glib";
           "cl-cffi-gtk-gobject" = quicklisp-to-nix-packages."cl-cffi-gtk-gobject";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-cffi-gtk-gdk" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cffi-gtk-gdk" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cffi-gtk-gdk.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-cffi-gtk-cairo" = quicklisp-to-nix-packages."cl-cffi-gtk-cairo";
           "cl-cffi-gtk-gdk-pixbuf" = quicklisp-to-nix-packages."cl-cffi-gtk-gdk-pixbuf";
           "cl-cffi-gtk-gio" = quicklisp-to-nix-packages."cl-cffi-gtk-gio";
           "cl-cffi-gtk-glib" = quicklisp-to-nix-packages."cl-cffi-gtk-glib";
           "cl-cffi-gtk-gobject" = quicklisp-to-nix-packages."cl-cffi-gtk-gobject";
           "cl-cffi-gtk-pango" = quicklisp-to-nix-packages."cl-cffi-gtk-pango";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-cffi-gtk-cairo" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cffi-gtk-cairo" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cffi-gtk-cairo.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-cffi-gtk-glib" = quicklisp-to-nix-packages."cl-cffi-gtk-glib";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
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
           "rt" = quicklisp-to-nix-packages."rt";
       }));


  "cl-async-util" = quicklisp-to-nix-packages."cl-async";


  "cl-colors2" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-colors2" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-colors2.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "clunit2" = quicklisp-to-nix-packages."clunit2";
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


  "cffi-toolchain" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi-toolchain" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi-toolchain.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "asdf" = quicklisp-to-nix-packages."asdf";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "jpl-util" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."jpl-util" or (x: {}))
       (import ./quicklisp-to-nix-output/jpl-util.nix {
         inherit fetchurl;
       }));


  "jpl-queues" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."jpl-queues" or (x: {}))
       (import ./quicklisp-to-nix-output/jpl-queues.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "jpl-util" = quicklisp-to-nix-packages."jpl-util";
       }));


  "eager-future2" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."eager-future2" or (x: {}))
       (import ./quicklisp-to-nix-output/eager-future2.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "vom" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."vom" or (x: {}))
       (import ./quicklisp-to-nix-output/vom.nix {
         inherit fetchurl;
       }));


  "clunit2" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clunit2" or (x: {}))
       (import ./quicklisp-to-nix-output/clunit2.nix {
         inherit fetchurl;
       }));


  "rt" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."rt" or (x: {}))
       (import ./quicklisp-to-nix-output/rt.nix {
         inherit fetchurl;
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


  "trivial-with-current-source-form" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-with-current-source-form" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-with-current-source-form.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
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


  "xml_dot_location" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."xml_dot_location" or (x: {}))
       (import ./quicklisp-to-nix-output/xml_dot_location.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "cxml-stp" = quicklisp-to-nix-packages."cxml-stp";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "lift" = quicklisp-to-nix-packages."lift";
           "more-conditions" = quicklisp-to-nix-packages."more-conditions";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
           "puri" = quicklisp-to-nix-packages."puri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "xpath" = quicklisp-to-nix-packages."xpath";
           "yacc" = quicklisp-to-nix-packages."yacc";
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


  "vecto" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."vecto" or (x: {}))
       (import ./quicklisp-to-nix-output/vecto.nix {
         inherit fetchurl;
           "cl-aa" = quicklisp-to-nix-packages."cl-aa";
           "cl-paths" = quicklisp-to-nix-packages."cl-paths";
           "cl-vectors" = quicklisp-to-nix-packages."cl-vectors";
           "salza2" = quicklisp-to-nix-packages."salza2";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "zpb-ttf" = quicklisp-to-nix-packages."zpb-ttf";
           "zpng" = quicklisp-to-nix-packages."zpng";
       }));


  "varjo" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."varjo" or (x: {}))
       (import ./quicklisp-to-nix-output/varjo.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "fn" = quicklisp-to-nix-packages."fn";
           "glsl-docs" = quicklisp-to-nix-packages."glsl-docs";
           "glsl-spec" = quicklisp-to-nix-packages."glsl-spec";
           "glsl-symbols" = quicklisp-to-nix-packages."glsl-symbols";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "parse-float" = quicklisp-to-nix-packages."parse-float";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "vas-string-metrics" = quicklisp-to-nix-packages."vas-string-metrics";
       }));


  "uuid" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uuid" or (x: {}))
       (import ./quicklisp-to-nix-output/uuid.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
       }));


  "utilities_dot_print-tree" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."utilities_dot_print-tree" or (x: {}))
       (import ./quicklisp-to-nix-output/utilities_dot_print-tree.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "utilities_dot_print-items" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."utilities_dot_print-items" or (x: {}))
       (import ./quicklisp-to-nix-output/utilities_dot_print-items.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
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


  "unix-options" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."unix-options" or (x: {}))
       (import ./quicklisp-to-nix-output/unix-options.nix {
         inherit fetchurl;
       }));


  "uiop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uiop" or (x: {}))
       (import ./quicklisp-to-nix-output/uiop.nix {
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
           "mgl-pax" = quicklisp-to-nix-packages."mgl-pax";
       }));


  "trivial-types" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-types" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-types.nix {
         inherit fetchurl;
       }));


  "trivial-shell" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-shell" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-shell.nix {
         inherit fetchurl;
       }));


  "trivial-package-local-nicknames" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-package-local-nicknames" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-package-local-nicknames.nix {
         inherit fetchurl;
       }));


  "trivial-mimes" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-mimes" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-mimes.nix {
         inherit fetchurl;
       }));


  "trivial-main-thread" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-main-thread" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-main-thread.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "array-utils" = quicklisp-to-nix-packages."array-utils";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "dissect" = quicklisp-to-nix-packages."dissect";
           "simple-tasks" = quicklisp-to-nix-packages."simple-tasks";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "trivial-indent" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-indent" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-indent.nix {
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


  "trivial-features" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-features" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-features.nix {
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


  "trivial-arguments" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-arguments" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-arguments.nix {
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


  "trees" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trees" or (x: {}))
       (import ./quicklisp-to-nix-output/trees.nix {
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


  "sycamore" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."sycamore" or (x: {}))
       (import ./quicklisp-to-nix-output/sycamore.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-fuzz" = quicklisp-to-nix-packages."cl-fuzz";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "lisp-unit" = quicklisp-to-nix-packages."lisp-unit";
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
           "cl-change-case" = quicklisp-to-nix-packages."cl-change-case";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-ppcre-unicode" = quicklisp-to-nix-packages."cl-ppcre-unicode";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
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


  "spinneret" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."spinneret" or (x: {}))
       (import ./quicklisp-to-nix-output/spinneret.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
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
           "parenscript" = quicklisp-to-nix-packages."parenscript";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
           "serapeum" = quicklisp-to-nix-packages."serapeum";
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
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-file-size" = quicklisp-to-nix-packages."trivial-file-size";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-macroexpand-all" = quicklisp-to-nix-packages."trivial-macroexpand-all";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "smug" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."smug" or (x: {}))
       (import ./quicklisp-to-nix-output/smug.nix {
         inherit fetchurl;
           "asdf-package-system" = quicklisp-to-nix-packages."asdf-package-system";
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


  "slynk" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."slynk" or (x: {}))
       (import ./quicklisp-to-nix-output/slynk.nix {
         inherit fetchurl;
       }));


  "simple-date-time" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."simple-date-time" or (x: {}))
       (import ./quicklisp-to-nix-output/simple-date-time.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
       }));


  "simple-date" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."simple-date" or (x: {}))
       (import ./quicklisp-to-nix-output/simple-date.nix {
         inherit fetchurl;
           "fiveam" = quicklisp-to-nix-packages."fiveam";
       }));


  "serapeum" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."serapeum" or (x: {}))
       (import ./quicklisp-to-nix-output/serapeum.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
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
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
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
           "chipz" = quicklisp-to-nix-packages."chipz";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "parachute" = quicklisp-to-nix-packages."parachute";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "rfc2388" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."rfc2388" or (x: {}))
       (import ./quicklisp-to-nix-output/rfc2388.nix {
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


  "pythonic-string-reader" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."pythonic-string-reader" or (x: {}))
       (import ./quicklisp-to-nix-output/pythonic-string-reader.nix {
         inherit fetchurl;
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "puri" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."puri" or (x: {}))
       (import ./quicklisp-to-nix-output/puri.nix {
         inherit fetchurl;
           "ptester" = quicklisp-to-nix-packages."ptester";
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
           "cl-colors2" = quicklisp-to-nix-packages."cl-colors2";
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


  "postmodern" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."postmodern" or (x: {}))
       (import ./quicklisp-to-nix-output/postmodern.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
           "cl-postgres_plus_local-time" = quicklisp-to-nix-packages."cl-postgres_plus_local-time";
           "cl-postgres_slash_tests" = quicklisp-to-nix-packages."cl-postgres_slash_tests";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "global-vars" = quicklisp-to-nix-packages."global-vars";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "md5" = quicklisp-to-nix-packages."md5";
           "s-sql" = quicklisp-to-nix-packages."s-sql";
           "s-sql_slash_tests" = quicklisp-to-nix-packages."s-sql_slash_tests";
           "simple-date" = quicklisp-to-nix-packages."simple-date";
           "simple-date_slash_postgres-glue" = quicklisp-to-nix-packages."simple-date_slash_postgres-glue";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "uax-15" = quicklisp-to-nix-packages."uax-15";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "usocket" = quicklisp-to-nix-packages."usocket";
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


  "physical-quantities" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."physical-quantities" or (x: {}))
       (import ./quicklisp-to-nix-output/physical-quantities.nix {
         inherit fetchurl;
           "parseq" = quicklisp-to-nix-packages."parseq";
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


  "parser_dot_common-rules" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parser_dot_common-rules" or (x: {}))
       (import ./quicklisp-to-nix-output/parser_dot_common-rules.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "esrap" = quicklisp-to-nix-packages."esrap";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-with-current-source-form" = quicklisp-to-nix-packages."trivial-with-current-source-form";
       }));


  "parser-combinators" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parser-combinators" or (x: {}))
       (import ./quicklisp-to-nix-output/parser-combinators.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "iterate" = quicklisp-to-nix-packages."iterate";
       }));


  "parse-number" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parse-number" or (x: {}))
       (import ./quicklisp-to-nix-output/parse-number.nix {
         inherit fetchurl;
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


  "parachute" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parachute" or (x: {}))
       (import ./quicklisp-to-nix-output/parachute.nix {
         inherit fetchurl;
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "form-fiddle" = quicklisp-to-nix-packages."form-fiddle";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "osicat" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."osicat" or (x: {}))
       (import ./quicklisp-to-nix-output/osicat.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "rt" = quicklisp-to-nix-packages."rt";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
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


  "net-telent-date" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."net-telent-date" or (x: {}))
       (import ./quicklisp-to-nix-output/net-telent-date.nix {
         inherit fetchurl;
       }));


  "named-readtables" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."named-readtables" or (x: {}))
       (import ./quicklisp-to-nix-output/named-readtables.nix {
         inherit fetchurl;
       }));


  "mt19937" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."mt19937" or (x: {}))
       (import ./quicklisp-to-nix-output/mt19937.nix {
         inherit fetchurl;
       }));


  "more-conditions" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."more-conditions" or (x: {}))
       (import ./quicklisp-to-nix-output/more-conditions.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
       }));


  "moptilities" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."moptilities" or (x: {}))
       (import ./quicklisp-to-nix-output/moptilities.nix {
         inherit fetchurl;
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
       }));


  "mmap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."mmap" or (x: {}))
       (import ./quicklisp-to-nix-output/mmap.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
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


  "minheap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."minheap" or (x: {}))
       (import ./quicklisp-to-nix-output/minheap.nix {
         inherit fetchurl;
       }));


  "mgl-pax" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."mgl-pax" or (x: {}))
       (import ./quicklisp-to-nix-output/mgl-pax.nix {
         inherit fetchurl;
           "_3bmd" = quicklisp-to-nix-packages."_3bmd";
           "_3bmd-ext-code-blocks" = quicklisp-to-nix-packages."_3bmd-ext-code-blocks";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "colorize" = quicklisp-to-nix-packages."colorize";
           "md5" = quicklisp-to-nix-packages."md5";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "pythonic-string-reader" = quicklisp-to-nix-packages."pythonic-string-reader";
           "swank" = quicklisp-to-nix-packages."swank";
       }));


  "metatilities-base" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."metatilities-base" or (x: {}))
       (import ./quicklisp-to-nix-output/metatilities-base.nix {
         inherit fetchurl;
       }));


  "metabang-bind" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."metabang-bind" or (x: {}))
       (import ./quicklisp-to-nix-output/metabang-bind.nix {
         inherit fetchurl;
       }));


  "md5" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."md5" or (x: {}))
       (import ./quicklisp-to-nix-output/md5.nix {
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
           "hu_dot_dwim_dot_stefil" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "lla" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lla" or (x: {}))
       (import ./quicklisp-to-nix-output/lla.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "array-operations" = quicklisp-to-nix-packages."array-operations";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-num-utils" = quicklisp-to-nix-packages."cl-num-utils";
           "cl-slice" = quicklisp-to-nix-packages."cl-slice";
           "clunit" = quicklisp-to-nix-packages."clunit";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "lisp-namespace" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lisp-namespace" or (x: {}))
       (import ./quicklisp-to-nix-output/lisp-namespace.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "lisp-binary" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lisp-binary" or (x: {}))
       (import ./quicklisp-to-nix-output/lisp-binary.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "moptilities" = quicklisp-to-nix-packages."moptilities";
           "quasiquote-2_dot_0" = quicklisp-to-nix-packages."quasiquote-2_dot_0";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "lift" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lift" or (x: {}))
       (import ./quicklisp-to-nix-output/lift.nix {
         inherit fetchurl;
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
       }));


  "jsown" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."jsown" or (x: {}))
       (import ./quicklisp-to-nix-output/jsown.nix {
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
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "idna" = quicklisp-to-nix-packages."idna";
           "iolib_dot_asdf" = quicklisp-to-nix-packages."iolib_dot_asdf";
           "iolib_dot_base" = quicklisp-to-nix-packages."iolib_dot_base";
           "iolib_dot_common-lisp" = quicklisp-to-nix-packages."iolib_dot_common-lisp";
           "iolib_dot_conf" = quicklisp-to-nix-packages."iolib_dot_conf";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swap-bytes" = quicklisp-to-nix-packages."swap-bytes";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "inferior-shell" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."inferior-shell" or (x: {}))
       (import ./quicklisp-to-nix-output/inferior-shell.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "asdf" = quicklisp-to-nix-packages."asdf";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fare-mop" = quicklisp-to-nix-packages."fare-mop";
           "fare-quasiquote" = quicklisp-to-nix-packages."fare-quasiquote";
           "fare-quasiquote-extras" = quicklisp-to-nix-packages."fare-quasiquote-extras";
           "fare-quasiquote-optima" = quicklisp-to-nix-packages."fare-quasiquote-optima";
           "fare-quasiquote-readtable" = quicklisp-to-nix-packages."fare-quasiquote-readtable";
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
           "hu_dot_dwim_dot_stefil" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_quasiquote" = quicklisp-to-nix-packages."trivia_dot_quasiquote";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
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
           "cxml-stp" = quicklisp-to-nix-packages."cxml-stp";
           "drakma" = quicklisp-to-nix-packages."drakma";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "md5" = quicklisp-to-nix-packages."md5";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swank" = quicklisp-to-nix-packages."swank";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "xpath" = quicklisp-to-nix-packages."xpath";
       }));


  "hunchensocket" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hunchensocket" or (x: {}))
       (import ./quicklisp-to-nix-output/hunchensocket.nix {
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
           "fiasco" = quicklisp-to-nix-packages."fiasco";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "hunchentoot" = quicklisp-to-nix-packages."hunchentoot";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "md5" = quicklisp-to-nix-packages."md5";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "hu_dot_dwim_dot_defclass-star" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_defclass-star" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_defclass-star.nix {
         inherit fetchurl;
           "hu_dot_dwim_dot_asdf" = quicklisp-to-nix-packages."hu_dot_dwim_dot_asdf";
           "hu_dot_dwim_dot_common" = quicklisp-to-nix-packages."hu_dot_dwim_dot_common";
           "hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def_plus_swank" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def_plus_swank";
       }));


  "hu_dot_dwim_dot_asdf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_asdf" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_asdf.nix {
         inherit fetchurl;
           "asdf" = quicklisp-to-nix-packages."asdf";
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


  "heap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."heap" or (x: {}))
       (import ./quicklisp-to-nix-output/heap.nix {
         inherit fetchurl;
       }));


  "gettext" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."gettext" or (x: {}))
       (import ./quicklisp-to-nix-output/gettext.nix {
         inherit fetchurl;
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "yacc" = quicklisp-to-nix-packages."yacc";
       }));


  "generic-cl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."generic-cl" or (x: {}))
       (import ./quicklisp-to-nix-output/generic-cl.nix {
         inherit fetchurl;
           "agutil" = quicklisp-to-nix-packages."agutil";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arrows" = quicklisp-to-nix-packages."arrows";
           "cl-custom-hash-table" = quicklisp-to-nix-packages."cl-custom-hash-table";
           "cl-environments" = quicklisp-to-nix-packages."cl-environments";
           "cl-form-types" = quicklisp-to-nix-packages."cl-form-types";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "generic-cl_dot_arithmetic" = quicklisp-to-nix-packages."generic-cl_dot_arithmetic";
           "generic-cl_dot_collector" = quicklisp-to-nix-packages."generic-cl_dot_collector";
           "generic-cl_dot_comparison" = quicklisp-to-nix-packages."generic-cl_dot_comparison";
           "generic-cl_dot_container" = quicklisp-to-nix-packages."generic-cl_dot_container";
           "generic-cl_dot_internal" = quicklisp-to-nix-packages."generic-cl_dot_internal";
           "generic-cl_dot_iterator" = quicklisp-to-nix-packages."generic-cl_dot_iterator";
           "generic-cl_dot_lazy-seq" = quicklisp-to-nix-packages."generic-cl_dot_lazy-seq";
           "generic-cl_dot_map" = quicklisp-to-nix-packages."generic-cl_dot_map";
           "generic-cl_dot_math" = quicklisp-to-nix-packages."generic-cl_dot_math";
           "generic-cl_dot_object" = quicklisp-to-nix-packages."generic-cl_dot_object";
           "generic-cl_dot_sequence" = quicklisp-to-nix-packages."generic-cl_dot_sequence";
           "generic-cl_dot_set" = quicklisp-to-nix-packages."generic-cl_dot_set";
           "introspect-environment" = quicklisp-to-nix-packages."introspect-environment";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-namespace" = quicklisp-to-nix-packages."lisp-namespace";
           "optima" = quicklisp-to-nix-packages."optima";
           "parse-declarations-1_dot_0" = quicklisp-to-nix-packages."parse-declarations-1_dot_0";
           "static-dispatch" = quicklisp-to-nix-packages."static-dispatch";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivia" = quicklisp-to-nix-packages."trivia";
           "trivia_dot_balland2006" = quicklisp-to-nix-packages."trivia_dot_balland2006";
           "trivia_dot_level0" = quicklisp-to-nix-packages."trivia_dot_level0";
           "trivia_dot_level1" = quicklisp-to-nix-packages."trivia_dot_level1";
           "trivia_dot_level2" = quicklisp-to-nix-packages."trivia_dot_level2";
           "trivia_dot_trivial" = quicklisp-to-nix-packages."trivia_dot_trivial";
           "trivial-cltl2" = quicklisp-to-nix-packages."trivial-cltl2";
           "type-i" = quicklisp-to-nix-packages."type-i";
       }));


  "fset" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fset" or (x: {}))
       (import ./quicklisp-to-nix-output/fset.nix {
         inherit fetchurl;
           "misc-extensions" = quicklisp-to-nix-packages."misc-extensions";
           "mt19937" = quicklisp-to-nix-packages."mt19937";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "form-fiddle" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."form-fiddle" or (x: {}))
       (import ./quicklisp-to-nix-output/form-fiddle.nix {
         inherit fetchurl;
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "float-features" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."float-features" or (x: {}))
       (import ./quicklisp-to-nix-output/float-features.nix {
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


  "file-attributes" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."file-attributes" or (x: {}))
       (import ./quicklisp-to-nix-output/file-attributes.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
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


  "fare-utils" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-utils" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-utils.nix {
         inherit fetchurl;
           "asdf" = quicklisp-to-nix-packages."asdf";
       }));


  "fare-quasiquote" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-quasiquote" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-quasiquote.nix {
         inherit fetchurl;
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
       }));


  "fare-mop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-mop" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-mop.nix {
         inherit fetchurl;
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "fare-utils" = quicklisp-to-nix-packages."fare-utils";
       }));


  "fare-csv" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fare-csv" or (x: {}))
       (import ./quicklisp-to-nix-output/fare-csv.nix {
         inherit fetchurl;
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
           "trivial-with-current-source-form" = quicklisp-to-nix-packages."trivial-with-current-source-form";
       }));


  "esrap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."esrap" or (x: {}))
       (import ./quicklisp-to-nix-output/esrap.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
           "trivial-with-current-source-form" = quicklisp-to-nix-packages."trivial-with-current-source-form";
       }));


  "enchant" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."enchant" or (x: {}))
       (import ./quicklisp-to-nix-output/enchant.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
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


  "djula" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."djula" or (x: {}))
       (import ./quicklisp-to-nix-output/djula.nix {
         inherit fetchurl;
           "access" = quicklisp-to-nix-packages."access";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arnesi" = quicklisp-to-nix-packages."arnesi";
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-locale" = quicklisp-to-nix-packages."cl-locale";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-slice" = quicklisp-to-nix-packages."cl-slice";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "gettext" = quicklisp-to-nix-packages."gettext";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "parser-combinators" = quicklisp-to-nix-packages."parser-combinators";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
           "yacc" = quicklisp-to-nix-packages."yacc";
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
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
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
           "uiop" = quicklisp-to-nix-packages."uiop";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
       }));


  "defclass-std" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."defclass-std" or (x: {}))
       (import ./quicklisp-to-nix-output/defclass-std.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
       }));


  "dbus" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbus" or (x: {}))
       (import ./quicklisp-to-nix-output/dbus.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "asdf-package-system" = quicklisp-to-nix-packages."asdf-package-system";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-xmlspam" = quicklisp-to-nix-packages."cl-xmlspam";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "idna" = quicklisp-to-nix-packages."idna";
           "ieee-floats" = quicklisp-to-nix-packages."ieee-floats";
           "iolib" = quicklisp-to-nix-packages."iolib";
           "iolib_dot_asdf" = quicklisp-to-nix-packages."iolib_dot_asdf";
           "iolib_dot_base" = quicklisp-to-nix-packages."iolib_dot_base";
           "iolib_dot_common-lisp" = quicklisp-to-nix-packages."iolib_dot_common-lisp";
           "iolib_dot_conf" = quicklisp-to-nix-packages."iolib_dot_conf";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "puri" = quicklisp-to-nix-packages."puri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swap-bytes" = quicklisp-to-nix-packages."swap-bytes";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
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
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "sqlite" = quicklisp-to-nix-packages."sqlite";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "dbd-postgres" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbd-postgres" or (x: {}))
       (import ./quicklisp-to-nix-output/dbd-postgres.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "md5" = quicklisp-to-nix-packages."md5";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "uax-15" = quicklisp-to-nix-packages."uax-15";
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
           "cl-mysql" = quicklisp-to-nix-packages."cl-mysql";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "data-table" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."data-table" or (x: {}))
       (import ./quicklisp-to-nix-output/data-table.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-unit2" = quicklisp-to-nix-packages."lisp-unit2";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
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
           "cxml_slash_test" = quicklisp-to-nix-packages."cxml_slash_test";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
           "puri" = quicklisp-to-nix-packages."puri";
           "rt" = quicklisp-to-nix-packages."rt";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "xpath" = quicklisp-to-nix-packages."xpath";
           "xpath_slash_test" = quicklisp-to-nix-packages."xpath_slash_test";
           "yacc" = quicklisp-to-nix-packages."yacc";
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
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "hu_dot_dwim_dot_stefil" = quicklisp-to-nix-packages."hu_dot_dwim_dot_stefil";
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


  "clx" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clx" or (x: {}))
       (import ./quicklisp-to-nix-output/clx.nix {
         inherit fetchurl;
           "fiasco" = quicklisp-to-nix-packages."fiasco";
       }));


  "clump" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clump" or (x: {}))
       (import ./quicklisp-to-nix-output/clump.nix {
         inherit fetchurl;
           "acclimation" = quicklisp-to-nix-packages."acclimation";
           "clump-2-3-tree" = quicklisp-to-nix-packages."clump-2-3-tree";
           "clump-binary-tree" = quicklisp-to-nix-packages."clump-binary-tree";
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


  "closer-mop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."closer-mop" or (x: {}))
       (import ./quicklisp-to-nix-output/closer-mop.nix {
         inherit fetchurl;
       }));


  "clfswm" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clfswm" or (x: {}))
       (import ./quicklisp-to-nix-output/clfswm.nix {
         inherit fetchurl;
           "clx" = quicklisp-to-nix-packages."clx";
       }));


  "classowary" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."classowary" or (x: {}))
       (import ./quicklisp-to-nix-output/classowary.nix {
         inherit fetchurl;
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
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
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "cl-who" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-who" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-who.nix {
         inherit fetchurl;
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
       }));


  "cl-webkit2" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-webkit2" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-webkit2.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-cffi-gtk" = quicklisp-to-nix-packages."cl-cffi-gtk";
           "cl-cffi-gtk-cairo" = quicklisp-to-nix-packages."cl-cffi-gtk-cairo";
           "cl-cffi-gtk-gdk" = quicklisp-to-nix-packages."cl-cffi-gtk-gdk";
           "cl-cffi-gtk-gdk-pixbuf" = quicklisp-to-nix-packages."cl-cffi-gtk-gdk-pixbuf";
           "cl-cffi-gtk-gio" = quicklisp-to-nix-packages."cl-cffi-gtk-gio";
           "cl-cffi-gtk-glib" = quicklisp-to-nix-packages."cl-cffi-gtk-glib";
           "cl-cffi-gtk-gobject" = quicklisp-to-nix-packages."cl-cffi-gtk-gobject";
           "cl-cffi-gtk-pango" = quicklisp-to-nix-packages."cl-cffi-gtk-pango";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
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
           "cl-colors2" = quicklisp-to-nix-packages."cl-colors2";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
           "prove" = quicklisp-to-nix-packages."prove";
       }));


  "cl-syslog" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syslog" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syslog.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "global-vars" = quicklisp-to-nix-packages."global-vars";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "usocket" = quicklisp-to-nix-packages."usocket";
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


  "cl-syntax" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax.nix {
         inherit fetchurl;
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cl-svg" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-svg" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-svg.nix {
         inherit fetchurl;
       }));


  "cl-store" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-store" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-store.nix {
         inherit fetchurl;
           "rt" = quicklisp-to-nix-packages."rt";
       }));


  "cl-speedy-queue" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-speedy-queue" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-speedy-queue.nix {
         inherit fetchurl;
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


  "cl-smt-lib" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-smt-lib" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-smt-lib.nix {
         inherit fetchurl;
           "asdf-package-system" = quicklisp-to-nix-packages."asdf-package-system";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cl-slice" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-slice" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-slice.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "clunit" = quicklisp-to-nix-packages."clunit";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
       }));


  "cl-shellwords" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-shellwords" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-shellwords.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
       }));


  "cl-reexport" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-reexport" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-reexport.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "cl-qprint" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-qprint" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-qprint.nix {
         inherit fetchurl;
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cl-qrencode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-qrencode" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-qrencode.nix {
         inherit fetchurl;
           "salza2" = quicklisp-to-nix-packages."salza2";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "zpng" = quicklisp-to-nix-packages."zpng";
       }));


  "cl-protobufs" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-protobufs" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-protobufs.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "asdf" = quicklisp-to-nix-packages."asdf";
           "babel" = quicklisp-to-nix-packages."babel";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-prevalence" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-prevalence" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-prevalence.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "s-sysdeps" = quicklisp-to-nix-packages."s-sysdeps";
           "s-xml" = quicklisp-to-nix-packages."s-xml";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "usocket-server" = quicklisp-to-nix-packages."usocket-server";
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


  "cl-pattern" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-pattern" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-pattern.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "cl-paths-ttf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-paths-ttf" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-paths-ttf.nix {
         inherit fetchurl;
           "cl-paths" = quicklisp-to-nix-packages."cl-paths";
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


  "cl-mustache" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-mustache" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-mustache.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "cl-markup" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-markup" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-markup.nix {
         inherit fetchurl;
       }));


  "cl-locale" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-locale" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-locale.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "arnesi" = quicklisp-to-nix-packages."arnesi";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
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


  "cl-html-diff" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-html-diff" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-html-diff.nix {
         inherit fetchurl;
           "cl-difflib" = quicklisp-to-nix-packages."cl-difflib";
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


  "cl-heap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-heap" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-heap.nix {
         inherit fetchurl;
       }));


  "cl-gobject-introspection" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-gobject-introspection" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-gobject-introspection.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
       }));


  "cl-geometry" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-geometry" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-geometry.nix {
         inherit fetchurl;
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trees" = quicklisp-to-nix-packages."trees";
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


  "cl-emb" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-emb" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-emb.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
       }));


  "cl-dot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-dot" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-dot.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "cl-digraph" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-digraph" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-digraph.nix {
         inherit fetchurl;
       }));


  "cl-dbi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-dbi" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-dbi.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "dbi" = quicklisp-to-nix-packages."dbi";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
       }));


  "cl-custom-hash-table" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-custom-hash-table" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-custom-hash-table.nix {
         inherit fetchurl;
       }));


  "cl-cuda" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cuda" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cuda.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-pattern" = quicklisp-to-nix-packages."cl-pattern";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-reexport" = quicklisp-to-nix-packages."cl-reexport";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "external-program" = quicklisp-to-nix-packages."external-program";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "osicat" = quicklisp-to-nix-packages."osicat";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
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
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "quri" = quicklisp-to-nix-packages."quri";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "cl-containers" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-containers" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-containers.nix {
         inherit fetchurl;
           "asdf-system-connections" = quicklisp-to-nix-packages."asdf-system-connections";
           "metatilities-base" = quicklisp-to-nix-packages."metatilities-base";
           "moptilities" = quicklisp-to-nix-packages."moptilities";
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


  "cl-cffi-gtk" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cffi-gtk" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cffi-gtk.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-cffi-gtk-cairo" = quicklisp-to-nix-packages."cl-cffi-gtk-cairo";
           "cl-cffi-gtk-gdk" = quicklisp-to-nix-packages."cl-cffi-gtk-gdk";
           "cl-cffi-gtk-gdk-pixbuf" = quicklisp-to-nix-packages."cl-cffi-gtk-gdk-pixbuf";
           "cl-cffi-gtk-gio" = quicklisp-to-nix-packages."cl-cffi-gtk-gio";
           "cl-cffi-gtk-glib" = quicklisp-to-nix-packages."cl-cffi-gtk-glib";
           "cl-cffi-gtk-gobject" = quicklisp-to-nix-packages."cl-cffi-gtk-gobject";
           "cl-cffi-gtk-pango" = quicklisp-to-nix-packages."cl-cffi-gtk-pango";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
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
           "cl-colors2" = quicklisp-to-nix-packages."cl-colors2";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
       }));


  "cl-annot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-annot" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-annot.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
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
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "usocket" = quicklisp-to-nix-packages."usocket";
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


  "chunga" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chunga" or (x: {}))
       (import ./quicklisp-to-nix-output/chunga.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "chipz" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chipz" or (x: {}))
       (import ./quicklisp-to-nix-output/chipz.nix {
         inherit fetchurl;
       }));


  "check-it" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."check-it" or (x: {}))
       (import ./quicklisp-to-nix-output/check-it.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "optima" = quicklisp-to-nix-packages."optima";
           "stefil" = quicklisp-to-nix-packages."stefil";
       }));


  "chanl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chanl" or (x: {}))
       (import ./quicklisp-to-nix-output/chanl.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "fiveam" = quicklisp-to-nix-packages."fiveam";
       }));


  "cffi-uffi-compat" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi-uffi-compat" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi-uffi-compat.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
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


  "calispel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."calispel" or (x: {}))
       (import ./quicklisp-to-nix-output/calispel.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "eager-future2" = quicklisp-to-nix-packages."eager-future2";
           "jpl-queues" = quicklisp-to-nix-packages."jpl-queues";
           "jpl-util" = quicklisp-to-nix-packages."jpl-util";
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


  "binpack" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."binpack" or (x: {}))
       (import ./quicklisp-to-nix-output/binpack.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "binomial-heap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."binomial-heap" or (x: {}))
       (import ./quicklisp-to-nix-output/binomial-heap.nix {
         inherit fetchurl;
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


  "array-operations" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."array-operations" or (x: {}))
       (import ./quicklisp-to-nix-output/array-operations.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "clunit2" = quicklisp-to-nix-packages."clunit2";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
       }));


  "arnesi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."arnesi" or (x: {}))
       (import ./quicklisp-to-nix-output/arnesi.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "collectors" = quicklisp-to-nix-packages."collectors";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "swank" = quicklisp-to-nix-packages."swank";
           "symbol-munger" = quicklisp-to-nix-packages."symbol-munger";
       }));


  "anaphora" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."anaphora" or (x: {}))
       (import ./quicklisp-to-nix-output/anaphora.nix {
         inherit fetchurl;
           "rt" = quicklisp-to-nix-packages."rt";
       }));


  "alexandria" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."alexandria" or (x: {}))
       (import ./quicklisp-to-nix-output/alexandria.nix {
         inherit fetchurl;
       }));


  "acclimation" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."acclimation" or (x: {}))
       (import ./quicklisp-to-nix-output/acclimation.nix {
         inherit fetchurl;
       }));


  "access" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."access" or (x: {}))
       (import ./quicklisp-to-nix-output/access.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "lisp-unit2" = quicklisp-to-nix-packages."lisp-unit2";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "_3bmd" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."_3bmd" or (x: {}))
       (import ./quicklisp-to-nix-output/_3bmd.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "esrap" = quicklisp-to-nix-packages."esrap";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "trivial-with-current-source-form" = quicklisp-to-nix-packages."trivial-with-current-source-form";
       }));


  "_1am" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."_1am" or (x: {}))
       (import ./quicklisp-to-nix-output/_1am.nix {
         inherit fetchurl;
       }));


};
in
   quicklisp-to-nix-packages
