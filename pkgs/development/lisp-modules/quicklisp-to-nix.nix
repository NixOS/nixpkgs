{stdenv, fetchurl, pkgs, clwrapper}:
let quicklisp-to-nix-packages = rec {
  inherit stdenv fetchurl clwrapper pkgs quicklisp-to-nix-packages;

  callPackage = pkgs.lib.callPackageWith quicklisp-to-nix-packages;
  buildLispPackage = callPackage ./define-package.nix;
  qlOverrides = callPackage ./quicklisp-to-nix-overrides.nix {};

  "closure-common" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."closure-common" or (x: {}))
       (import ./quicklisp-to-nix-output/closure-common.nix {
         inherit fetchurl;
           "babel" = quicklisp-to-nix-packages."babel";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "let-plus" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."let-plus" or (x: {}))
       (import ./quicklisp-to-nix-output/let-plus.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
       }));


  "trivial-indent" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-indent" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-indent.nix {
         inherit fetchurl;
       }));


  "documentation-utils" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."documentation-utils" or (x: {}))
       (import ./quicklisp-to-nix-output/documentation-utils.nix {
         inherit fetchurl;
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "trivial-garbage" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-garbage" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-garbage.nix {
         inherit fetchurl;
       }));


  "cxml-xml" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml-xml" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml-xml.nix {
         inherit fetchurl;
           "closure-common" = quicklisp-to-nix-packages."closure-common";
           "puri" = quicklisp-to-nix-packages."puri";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cffi-toolchain" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi-toolchain" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi-toolchain.nix {
         inherit fetchurl;
           "cffi" = quicklisp-to-nix-packages."cffi";
       }));


  "map-set" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."map-set" or (x: {}))
       (import ./quicklisp-to-nix-output/map-set.nix {
         inherit fetchurl;
       }));


  "babel-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."babel-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/babel-streams.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cl-colors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-colors" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-colors.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
       }));


  "cl-ansi-text" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ansi-text" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ansi-text.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
       }));


  "plump-parser" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."plump-parser" or (x: {}))
       (import ./quicklisp-to-nix-output/plump-parser.nix {
         inherit fetchurl;
           "plump-dom" = quicklisp-to-nix-packages."plump-dom";
           "plump-lexer" = quicklisp-to-nix-packages."plump-lexer";
           "trivial-indent" = quicklisp-to-nix-packages."trivial-indent";
       }));


  "plump-lexer" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."plump-lexer" or (x: {}))
       (import ./quicklisp-to-nix-output/plump-lexer.nix {
         inherit fetchurl;
       }));


  "plump-dom" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."plump-dom" or (x: {}))
       (import ./quicklisp-to-nix-output/plump-dom.nix {
         inherit fetchurl;
           "array-utils" = quicklisp-to-nix-packages."array-utils";
       }));


  "form-fiddle" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."form-fiddle" or (x: {}))
       (import ./quicklisp-to-nix-output/form-fiddle.nix {
         inherit fetchurl;
           "documentation-utils" = quicklisp-to-nix-packages."documentation-utils";
       }));


  "clss" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clss" or (x: {}))
       (import ./quicklisp-to-nix-output/clss.nix {
         inherit fetchurl;
           "array-utils" = quicklisp-to-nix-packages."array-utils";
           "plump" = quicklisp-to-nix-packages."plump";
       }));


  "array-utils" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."array-utils" or (x: {}))
       (import ./quicklisp-to-nix-output/array-utils.nix {
         inherit fetchurl;
       }));


  "lack-util" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lack-util" or (x: {}))
       (import ./quicklisp-to-nix-output/lack-util.nix {
         inherit fetchurl;
           "ironclad" = quicklisp-to-nix-packages."ironclad";
       }));


  "lack-component" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lack-component" or (x: {}))
       (import ./quicklisp-to-nix-output/lack-component.nix {
         inherit fetchurl;
       }));


  "nibbles" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."nibbles" or (x: {}))
       (import ./quicklisp-to-nix-output/nibbles.nix {
         inherit fetchurl;
       }));


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


  "jonathan" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."jonathan" or (x: {}))
       (import ./quicklisp-to-nix-output/jonathan.nix {
         inherit fetchurl;
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
       }));


  "puri" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."puri" or (x: {}))
       (import ./quicklisp-to-nix-output/puri.nix {
         inherit fetchurl;
       }));


  "cl+ssl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl+ssl" or (x: {}))
       (import ./quicklisp-to-nix-output/cl+ssl.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "chunga" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chunga" or (x: {}))
       (import ./quicklisp-to-nix-output/chunga.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "cxml-test" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml-test" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml-test.nix {
         inherit fetchurl;
           "cxml-dom" = quicklisp-to-nix-packages."cxml-dom";
           "cxml-klacks" = quicklisp-to-nix-packages."cxml-klacks";
           "cxml-xml" = quicklisp-to-nix-packages."cxml-xml";
       }));


  "cxml-klacks" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml-klacks" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml-klacks.nix {
         inherit fetchurl;
           "cxml-xml" = quicklisp-to-nix-packages."cxml-xml";
       }));


  "cxml-dom" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml-dom" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml-dom.nix {
         inherit fetchurl;
           "cxml-xml" = quicklisp-to-nix-packages."cxml-xml";
       }));


  "named-readtables" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."named-readtables" or (x: {}))
       (import ./quicklisp-to-nix-output/named-readtables.nix {
         inherit fetchurl;
       }));


  "cl-annot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-annot" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-annot.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "metabang-bind" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."metabang-bind" or (x: {}))
       (import ./quicklisp-to-nix-output/metabang-bind.nix {
         inherit fetchurl;
       }));


  "cl-l10n-cldr" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-l10n-cldr" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-l10n-cldr.nix {
         inherit fetchurl;
       }));


  "cl-fad" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fad" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fad.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "cffi-grovel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi-grovel" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi-grovel.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-toolchain" = quicklisp-to-nix-packages."cffi-toolchain";
       }));


  "cl-libuv" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-libuv" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-libuv.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
       }));


  "cl-async-util" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async-util" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async-util.nix {
         inherit fetchurl;
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-async-base" = quicklisp-to-nix-packages."cl-async-base";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "vom" = quicklisp-to-nix-packages."vom";
       }));


  "cl-async-base" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async-base" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async-base.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
       }));


  "trivial-gray-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-gray-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-gray-streams.nix {
         inherit fetchurl;
       }));


  "uiop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uiop" or (x: {}))
       (import ./quicklisp-to-nix-output/uiop.nix {
         inherit fetchurl;
       }));


  "myway" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."myway" or (x: {}))
       (import ./quicklisp-to-nix-output/myway.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "map-set" = quicklisp-to-nix-packages."map-set";
           "quri" = quicklisp-to-nix-packages."quri";
       }));


  "do-urlencode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."do-urlencode" or (x: {}))
       (import ./quicklisp-to-nix-output/do-urlencode.nix {
         inherit fetchurl;
           "babel" = quicklisp-to-nix-packages."babel";
           "babel-streams" = quicklisp-to-nix-packages."babel-streams";
       }));


  "clack-v1-compat" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack-v1-compat" or (x: {}))
       (import ./quicklisp-to-nix-output/clack-v1-compat.nix {
         inherit fetchurl;
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
           "cl-emb" = quicklisp-to-nix-packages."cl-emb";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "prove" = quicklisp-to-nix-packages."prove";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "cl-emb" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-emb" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-emb.nix {
         inherit fetchurl;
       }));


  "anaphora" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."anaphora" or (x: {}))
       (import ./quicklisp-to-nix-output/anaphora.nix {
         inherit fetchurl;
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
       }));


  "wookie" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."wookie" or (x: {}))
       (import ./quicklisp-to-nix-output/wookie.nix {
         inherit fetchurl;
       }));


  "woo" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."woo" or (x: {}))
       (import ./quicklisp-to-nix-output/woo.nix {
         inherit fetchurl;
       }));


  "usocket" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."usocket" or (x: {}))
       (import ./quicklisp-to-nix-output/usocket.nix {
         inherit fetchurl;
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
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


  "trivial-backtrace" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-backtrace" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-backtrace.nix {
         inherit fetchurl;
       }));


  "stumpwm" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."stumpwm" or (x: {}))
       (import ./quicklisp-to-nix-output/stumpwm.nix {
         inherit fetchurl;
       }));


  "static-vectors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."static-vectors" or (x: {}))
       (import ./quicklisp-to-nix-output/static-vectors.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
       }));


  "split-sequence" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."split-sequence" or (x: {}))
       (import ./quicklisp-to-nix-output/split-sequence.nix {
         inherit fetchurl;
       }));


  "smart-buffer" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."smart-buffer" or (x: {}))
       (import ./quicklisp-to-nix-output/smart-buffer.nix {
         inherit fetchurl;
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
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
       }));


  "prove" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."prove" or (x: {}))
       (import ./quicklisp-to-nix-output/prove.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-ansi-text" = quicklisp-to-nix-packages."cl-ansi-text";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "proc-parse" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."proc-parse" or (x: {}))
       (import ./quicklisp-to-nix-output/proc-parse.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
       }));


  "plump" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."plump" or (x: {}))
       (import ./quicklisp-to-nix-output/plump.nix {
         inherit fetchurl;
           "plump-dom" = quicklisp-to-nix-packages."plump-dom";
           "plump-lexer" = quicklisp-to-nix-packages."plump-lexer";
           "plump-parser" = quicklisp-to-nix-packages."plump-parser";
       }));


  "optima" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."optima" or (x: {}))
       (import ./quicklisp-to-nix-output/optima.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
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
           "form-fiddle" = quicklisp-to-nix-packages."form-fiddle";
           "plump" = quicklisp-to-nix-packages."plump";
       }));


  "local-time" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."local-time" or (x: {}))
       (import ./quicklisp-to-nix-output/local-time.nix {
         inherit fetchurl;
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
       }));


  "lev" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lev" or (x: {}))
       (import ./quicklisp-to-nix-output/lev.nix {
         inherit fetchurl;
           "cffi" = quicklisp-to-nix-packages."cffi";
       }));


  "lack" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lack" or (x: {}))
       (import ./quicklisp-to-nix-output/lack.nix {
         inherit fetchurl;
           "lack-component" = quicklisp-to-nix-packages."lack-component";
           "lack-util" = quicklisp-to-nix-packages."lack-util";
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
           "nibbles" = quicklisp-to-nix-packages."nibbles";
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
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "swap-bytes" = quicklisp-to-nix-packages."swap-bytes";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "hunchentoot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hunchentoot" or (x: {}))
       (import ./quicklisp-to-nix-output/hunchentoot.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl+ssl" = quicklisp-to-nix-packages."cl+ssl";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "md5" = quicklisp-to-nix-packages."md5";
           "rfc2388" = quicklisp-to-nix-packages."rfc2388";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "http-body" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."http-body" or (x: {}))
       (import ./quicklisp-to-nix-output/http-body.nix {
         inherit fetchurl;
           "babel" = quicklisp-to-nix-packages."babel";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "jonathan" = quicklisp-to-nix-packages."jonathan";
           "quri" = quicklisp-to-nix-packages."quri";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "flexi-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."flexi-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/flexi-streams.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "fast-io" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fast-io" or (x: {}))
       (import ./quicklisp-to-nix-output/fast-io.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "fast-http" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."fast-http" or (x: {}))
       (import ./quicklisp-to-nix-output/fast-http.nix {
         inherit fetchurl;
       }));


  "external-program" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."external-program" or (x: {}))
       (import ./quicklisp-to-nix-output/external-program.nix {
         inherit fetchurl;
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
       }));


  "esrap" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."esrap" or (x: {}))
       (import ./quicklisp-to-nix-output/esrap.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "drakma" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."drakma" or (x: {}))
       (import ./quicklisp-to-nix-output/drakma.nix {
         inherit fetchurl;
           "chipz" = quicklisp-to-nix-packages."chipz";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "cl+ssl" = quicklisp-to-nix-packages."cl+ssl";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "puri" = quicklisp-to-nix-packages."puri";
           "usocket" = quicklisp-to-nix-packages."usocket";
       }));


  "dexador" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dexador" or (x: {}))
       (import ./quicklisp-to-nix-output/dexador.nix {
         inherit fetchurl;
       }));


  "cxml" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml.nix {
         inherit fetchurl;
           "cxml-dom" = quicklisp-to-nix-packages."cxml-dom";
           "cxml-klacks" = quicklisp-to-nix-packages."cxml-klacks";
           "cxml-test" = quicklisp-to-nix-packages."cxml-test";
       }));


  "css-lite" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."css-lite" or (x: {}))
       (import ./quicklisp-to-nix-output/css-lite.nix {
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


  "clx" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clx" or (x: {}))
       (import ./quicklisp-to-nix-output/clx.nix {
         inherit fetchurl;
       }));


  "cl-who" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-who" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-who.nix {
         inherit fetchurl;
       }));


  "cl-utilities" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-utilities" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-utilities.nix {
         inherit fetchurl;
       }));


  "cl-unicode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-unicode" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-unicode.nix {
         inherit fetchurl;
       }));


  "cl-syntax-annot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax-annot" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax-annot.nix {
         inherit fetchurl;
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
       }));


  "cl-reexport" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-reexport" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-reexport.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "cl-ppcre" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ppcre" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ppcre.nix {
         inherit fetchurl;
       }));


  "closer-mop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."closer-mop" or (x: {}))
       (import ./quicklisp-to-nix-output/closer-mop.nix {
         inherit fetchurl;
       }));


  "cl-l10n" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-l10n" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-l10n.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-l10n-cldr" = quicklisp-to-nix-packages."cl-l10n-cldr";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "cxml" = quicklisp-to-nix-packages."cxml";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
       }));


  "cl-json" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-json" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-json.nix {
         inherit fetchurl;
       }));


  "cl-fuse" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fuse" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fuse.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cffi-grovel" = quicklisp-to-nix-packages."cffi-grovel";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
       }));


  "cl-cookie" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cookie" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cookie.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "quri" = quicklisp-to-nix-packages."quri";
       }));


  "cl-base64" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-base64" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-base64.nix {
         inherit fetchurl;
       }));


  "cl-async" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async.nix {
         inherit fetchurl;
           "babel" = quicklisp-to-nix-packages."babel";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "cl-async-base" = quicklisp-to-nix-packages."cl-async-base";
           "cl-async-util" = quicklisp-to-nix-packages."cl-async-util";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "clack" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack" or (x: {}))
       (import ./quicklisp-to-nix-output/clack.nix {
         inherit fetchurl;
       }));


  "circular-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."circular-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/circular-streams.nix {
         inherit fetchurl;
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "chipz" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chipz" or (x: {}))
       (import ./quicklisp-to-nix-output/chipz.nix {
         inherit fetchurl;
       }));


  "cffi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cffi" or (x: {}))
       (import ./quicklisp-to-nix-output/cffi.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "babel" = quicklisp-to-nix-packages."babel";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "uiop" = quicklisp-to-nix-packages."uiop";
       }));


  "caveman" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."caveman" or (x: {}))
       (import ./quicklisp-to-nix-output/caveman.nix {
         inherit fetchurl;
           "anaphora" = quicklisp-to-nix-packages."anaphora";
           "cl-emb" = quicklisp-to-nix-packages."cl-emb";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-project" = quicklisp-to-nix-packages."cl-project";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "clack-v1-compat" = quicklisp-to-nix-packages."clack-v1-compat";
           "do-urlencode" = quicklisp-to-nix-packages."do-urlencode";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "myway" = quicklisp-to-nix-packages."myway";
       }));


  "bordeaux-threads" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."bordeaux-threads" or (x: {}))
       (import ./quicklisp-to-nix-output/bordeaux-threads.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
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


  "alexandria" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."alexandria" or (x: {}))
       (import ./quicklisp-to-nix-output/alexandria.nix {
         inherit fetchurl;
       }));


}; in quicklisp-to-nix-packages
