{stdenv, fetchurl, pkgs, clwrapper}:
let quicklisp-to-nix-packages = rec {
  inherit stdenv fetchurl clwrapper pkgs quicklisp-to-nix-packages;

  callPackage = pkgs.lib.callPackageWith quicklisp-to-nix-packages;
  buildLispPackage = callPackage ./define-package.nix;
  qlOverrides = callPackage ./quicklisp-to-nix-overrides.nix {};

  "asdf-system-connections" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."asdf-system-connections" or (x: {}))
       (import ./quicklisp-to-nix-output/asdf-system-connections.nix {
         inherit fetchurl;
       }));


  "closure-common" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."closure-common" or (x: {}))
       (import ./quicklisp-to-nix-output/closure-common.nix {
         inherit fetchurl;
           "babel" = quicklisp-to-nix-packages."babel";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "list-of" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."list-of" or (x: {}))
       (import ./quicklisp-to-nix-output/list-of.nix {
         inherit fetchurl;
       }));


  "parse-number" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parse-number" or (x: {}))
       (import ./quicklisp-to-nix-output/parse-number.nix {
         inherit fetchurl;
       }));


  "garbage-pools" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."garbage-pools" or (x: {}))
       (import ./quicklisp-to-nix-output/garbage-pools.nix {
         inherit fetchurl;
       }));


  "cl-containers" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-containers" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-containers.nix {
         inherit fetchurl;
           "metatilities-base" = quicklisp-to-nix-packages."metatilities-base";
           "asdf-system-connections" = quicklisp-to-nix-packages."asdf-system-connections";
       }));


  "dynamic-classes" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dynamic-classes" or (x: {}))
       (import ./quicklisp-to-nix-output/dynamic-classes.nix {
         inherit fetchurl;
           "metatilities-base" = quicklisp-to-nix-packages."metatilities-base";
       }));


  "metatilities-base" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."metatilities-base" or (x: {}))
       (import ./quicklisp-to-nix-output/metatilities-base.nix {
         inherit fetchurl;
       }));


  "cl-interpol" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-interpol" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-interpol.nix {
         inherit fetchurl;
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
       }));


  "cxml-xml" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml-xml" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml-xml.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "puri" = quicklisp-to-nix-packages."puri";
           "closure-common" = quicklisp-to-nix-packages."closure-common";
       }));


  "babel-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."babel-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/babel-streams.nix {
         inherit fetchurl;
       }));


  "map-set" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."map-set" or (x: {}))
       (import ./quicklisp-to-nix-output/map-set.nix {
         inherit fetchurl;
       }));


  "cl-ansi-text" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ansi-text" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ansi-text.nix {
         inherit fetchurl;
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "uuid" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uuid" or (x: {}))
       (import ./quicklisp-to-nix-output/uuid.nix {
         inherit fetchurl;
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "trivial-utf-8" = quicklisp-to-nix-packages."trivial-utf-8";
       }));


  "simple-date" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."simple-date" or (x: {}))
       (import ./quicklisp-to-nix-output/simple-date.nix {
         inherit fetchurl;
       }));


  "qmynd" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."qmynd" or (x: {}))
       (import ./quicklisp-to-nix-output/qmynd.nix {
         inherit fetchurl;
           "usocket" = quicklisp-to-nix-packages."usocket";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "salza2" = quicklisp-to-nix-packages."salza2";
           "list-of" = quicklisp-to-nix-packages."list-of";
           "ironclad" = quicklisp-to-nix-packages."ironclad";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "cl+ssl" = quicklisp-to-nix-packages."cl+ssl";
           "chipz" = quicklisp-to-nix-packages."chipz";
           "babel" = quicklisp-to-nix-packages."babel";
       }));


  "py-configparser" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."py-configparser" or (x: {}))
       (import ./quicklisp-to-nix-output/py-configparser.nix {
         inherit fetchurl;
           "parse-number" = quicklisp-to-nix-packages."parse-number";
       }));


  "postmodern" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."postmodern" or (x: {}))
       (import ./quicklisp-to-nix-output/postmodern.nix {
         inherit fetchurl;
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "mssql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."mssql" or (x: {}))
       (import ./quicklisp-to-nix-output/mssql.nix {
         inherit fetchurl;
           "cffi" = quicklisp-to-nix-packages."cffi";
           "garbage-pools" = quicklisp-to-nix-packages."garbage-pools";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "parse-number" = quicklisp-to-nix-packages."parse-number";
       }));


  "lparallel" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."lparallel" or (x: {}))
       (import ./quicklisp-to-nix-output/lparallel.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "ixf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."ixf" or (x: {}))
       (import ./quicklisp-to-nix-output/ixf.nix {
         inherit fetchurl;
       }));


  "db3" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."db3" or (x: {}))
       (import ./quicklisp-to-nix-output/db3.nix {
         inherit fetchurl;
       }));


  "cl-markdown" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-markdown" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-markdown.nix {
         inherit fetchurl;
           "metatilities-base" = quicklisp-to-nix-packages."metatilities-base";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
           "dynamic-classes" = quicklisp-to-nix-packages."dynamic-classes";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-containers" = quicklisp-to-nix-packages."cl-containers";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
       }));


  "cl-log" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-log" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-log.nix {
         inherit fetchurl;
       }));


  "cl-csv" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-csv" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-csv.nix {
         inherit fetchurl;
           "iterate" = quicklisp-to-nix-packages."iterate";
           "cl-interpol" = quicklisp-to-nix-packages."cl-interpol";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "abnf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."abnf" or (x: {}))
       (import ./quicklisp-to-nix-output/abnf.nix {
         inherit fetchurl;
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "esrap" = quicklisp-to-nix-packages."esrap";
       }));


  "named-readtables" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."named-readtables" or (x: {}))
       (import ./quicklisp-to-nix-output/named-readtables.nix {
         inherit fetchurl;
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
       }));


  "chunga" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."chunga" or (x: {}))
       (import ./quicklisp-to-nix-output/chunga.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
       }));


  "puri" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."puri" or (x: {}))
       (import ./quicklisp-to-nix-output/puri.nix {
         inherit fetchurl;
       }));


  "sqlite" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."sqlite" or (x: {}))
       (import ./quicklisp-to-nix-output/sqlite.nix {
         inherit fetchurl;
           "cffi" = quicklisp-to-nix-packages."cffi";
           "iterate" = quicklisp-to-nix-packages."iterate";
       }));


  "cl-postgres" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-postgres" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-postgres.nix {
         inherit fetchurl;
           "md5" = quicklisp-to-nix-packages."md5";
       }));


  "cxml-test" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cxml-test" or (x: {}))
       (import ./quicklisp-to-nix-output/cxml-test.nix {
         inherit fetchurl;
           "cxml-xml" = quicklisp-to-nix-packages."cxml-xml";
           "cxml-klacks" = quicklisp-to-nix-packages."cxml-klacks";
           "cxml-dom" = quicklisp-to-nix-packages."cxml-dom";
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


  "zpb-ttf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."zpb-ttf" or (x: {}))
       (import ./quicklisp-to-nix-output/zpb-ttf.nix {
         inherit fetchurl;
       }));


  "cl-store" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-store" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-store.nix {
         inherit fetchurl;
       }));


  "cl-paths-ttf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-paths-ttf" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-paths-ttf.nix {
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


  "cl-annot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-annot" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-annot.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "trivial-garbage" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-garbage" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-garbage.nix {
         inherit fetchurl;
       }));


  "uffi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uffi" or (x: {}))
       (import ./quicklisp-to-nix-output/uffi.nix {
         inherit fetchurl;
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
       }));


  "let-plus" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."let-plus" or (x: {}))
       (import ./quicklisp-to-nix-output/let-plus.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
       }));


  "cl-async-util" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async-util" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async-util.nix {
         inherit fetchurl;
           "vom" = quicklisp-to-nix-packages."vom";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cl-async-base" = quicklisp-to-nix-packages."cl-async-base";
           "cffi" = quicklisp-to-nix-packages."cffi";
       }));


  "trivial-gray-streams" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-gray-streams" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-gray-streams.nix {
         inherit fetchurl;
       }));


  "trivial-features" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-features" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-features.nix {
         inherit fetchurl;
       }));


  "uiop" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."uiop" or (x: {}))
       (import ./quicklisp-to-nix-output/uiop.nix {
         inherit fetchurl;
       }));


  "anaphora" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."anaphora" or (x: {}))
       (import ./quicklisp-to-nix-output/anaphora.nix {
         inherit fetchurl;
       }));


  "cl-project" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-project" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-project.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
           "prove" = quicklisp-to-nix-packages."prove";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-emb" = quicklisp-to-nix-packages."cl-emb";
       }));


  "cl-syntax" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax.nix {
         inherit fetchurl;
           "trivial-types" = quicklisp-to-nix-packages."trivial-types";
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
       }));


  "do-urlencode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."do-urlencode" or (x: {}))
       (import ./quicklisp-to-nix-output/do-urlencode.nix {
         inherit fetchurl;
           "babel" = quicklisp-to-nix-packages."babel";
           "babel-streams" = quicklisp-to-nix-packages."babel-streams";
       }));


  "myway" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."myway" or (x: {}))
       (import ./quicklisp-to-nix-output/myway.nix {
         inherit fetchurl;
           "quri" = quicklisp-to-nix-packages."quri";
           "map-set" = quicklisp-to-nix-packages."map-set";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "vom" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."vom" or (x: {}))
       (import ./quicklisp-to-nix-output/vom.nix {
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


  "trivial-indent" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-indent" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-indent.nix {
         inherit fetchurl;
       }));


  "trivial-backtrace" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."trivial-backtrace" or (x: {}))
       (import ./quicklisp-to-nix-output/trivial-backtrace.nix {
         inherit fetchurl;
       }));


  "swap-bytes" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."swap-bytes" or (x: {}))
       (import ./quicklisp-to-nix-output/swap-bytes.nix {
         inherit fetchurl;
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
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
           "xsubseq" = quicklisp-to-nix-packages."xsubseq";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
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
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "babel" = quicklisp-to-nix-packages."babel";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "query-fs" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."query-fs" or (x: {}))
       (import ./quicklisp-to-nix-output/query-fs.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-fuse" = quicklisp-to-nix-packages."cl-fuse";
           "cl-fuse-meta-fs" = quicklisp-to-nix-packages."cl-fuse-meta-fs";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "command-line-arguments" = quicklisp-to-nix-packages."command-line-arguments";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
       }));


  "prove" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."prove" or (x: {}))
       (import ./quicklisp-to-nix-output/prove.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-colors" = quicklisp-to-nix-packages."cl-colors";
           "cl-ansi-text" = quicklisp-to-nix-packages."cl-ansi-text";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "proc-parse" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."proc-parse" or (x: {}))
       (import ./quicklisp-to-nix-output/proc-parse.nix {
         inherit fetchurl;
           "babel" = quicklisp-to-nix-packages."babel";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "plump" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."plump" or (x: {}))
       (import ./quicklisp-to-nix-output/plump.nix {
         inherit fetchurl;
       }));


  "pgloader" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."pgloader" or (x: {}))
       (import ./quicklisp-to-nix-output/pgloader.nix {
         inherit fetchurl;
           "abnf" = quicklisp-to-nix-packages."abnf";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl-csv" = quicklisp-to-nix-packages."cl-csv";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
           "cl-log" = quicklisp-to-nix-packages."cl-log";
           "cl-markdown" = quicklisp-to-nix-packages."cl-markdown";
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "command-line-arguments" = quicklisp-to-nix-packages."command-line-arguments";
           "db3" = quicklisp-to-nix-packages."db3";
           "drakma" = quicklisp-to-nix-packages."drakma";
           "esrap" = quicklisp-to-nix-packages."esrap";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "ixf" = quicklisp-to-nix-packages."ixf";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "lparallel" = quicklisp-to-nix-packages."lparallel";
           "metabang-bind" = quicklisp-to-nix-packages."metabang-bind";
           "mssql" = quicklisp-to-nix-packages."mssql";
           "postmodern" = quicklisp-to-nix-packages."postmodern";
           "py-configparser" = quicklisp-to-nix-packages."py-configparser";
           "qmynd" = quicklisp-to-nix-packages."qmynd";
           "quri" = quicklisp-to-nix-packages."quri";
           "simple-date" = quicklisp-to-nix-packages."simple-date";
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "sqlite" = quicklisp-to-nix-packages."sqlite";
           "trivial-backtrace" = quicklisp-to-nix-packages."trivial-backtrace";
           "uiop" = quicklisp-to-nix-packages."uiop";
           "usocket" = quicklisp-to-nix-packages."usocket";
           "uuid" = quicklisp-to-nix-packages."uuid";
       }));


  "pcall" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."pcall" or (x: {}))
       (import ./quicklisp-to-nix-output/pcall.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "parenscript" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."parenscript" or (x: {}))
       (import ./quicklisp-to-nix-output/parenscript.nix {
         inherit fetchurl;
           "named-readtables" = quicklisp-to-nix-packages."named-readtables";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
       }));


  "optima" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."optima" or (x: {}))
       (import ./quicklisp-to-nix-output/optima.nix {
         inherit fetchurl;
           "closer-mop" = quicklisp-to-nix-packages."closer-mop";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "nibbles" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."nibbles" or (x: {}))
       (import ./quicklisp-to-nix-output/nibbles.nix {
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
       }));


  "local-time" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."local-time" or (x: {}))
       (import ./quicklisp-to-nix-output/local-time.nix {
         inherit fetchurl;
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
       }));


  "iolib" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."iolib" or (x: {}))
       (import ./quicklisp-to-nix-output/iolib.nix {
         inherit fetchurl;
       }));


  "ieee-floats" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."ieee-floats" or (x: {}))
       (import ./quicklisp-to-nix-output/ieee-floats.nix {
         inherit fetchurl;
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


  "hu_dot_dwim_dot_def" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_def" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_def.nix {
         inherit fetchurl;
       }));


  "hu_dot_dwim_dot_asdf" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."hu_dot_dwim_dot_asdf" or (x: {}))
       (import ./quicklisp-to-nix-output/hu_dot_dwim_dot_asdf.nix {
         inherit fetchurl;
       }));


  "http-body" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."http-body" or (x: {}))
       (import ./quicklisp-to-nix-output/http-body.nix {
         inherit fetchurl;
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "quri" = quicklisp-to-nix-packages."quri";
           "jonathan" = quicklisp-to-nix-packages."jonathan";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "fast-http" = quicklisp-to-nix-packages."fast-http";
           "cl-utilities" = quicklisp-to-nix-packages."cl-utilities";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "babel" = quicklisp-to-nix-packages."babel";
       }));


  "form-fiddle" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."form-fiddle" or (x: {}))
       (import ./quicklisp-to-nix-output/form-fiddle.nix {
         inherit fetchurl;
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
       }));


  "drakma" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."drakma" or (x: {}))
       (import ./quicklisp-to-nix-output/drakma.nix {
         inherit fetchurl;
           "usocket" = quicklisp-to-nix-packages."usocket";
           "puri" = quicklisp-to-nix-packages."puri";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "cl+ssl" = quicklisp-to-nix-packages."cl+ssl";
           "chunga" = quicklisp-to-nix-packages."chunga";
           "chipz" = quicklisp-to-nix-packages."chipz";
       }));


  "documentation-utils" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."documentation-utils" or (x: {}))
       (import ./quicklisp-to-nix-output/documentation-utils.nix {
         inherit fetchurl;
       }));


  "dexador" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dexador" or (x: {}))
       (import ./quicklisp-to-nix-output/dexador.nix {
         inherit fetchurl;
       }));


  "dbd-sqlite3" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbd-sqlite3" or (x: {}))
       (import ./quicklisp-to-nix-output/dbd-sqlite3.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
           "sqlite" = quicklisp-to-nix-packages."sqlite";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
       }));


  "dbd-postgres" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbd-postgres" or (x: {}))
       (import ./quicklisp-to-nix-output/dbd-postgres.nix {
         inherit fetchurl;
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-postgres" = quicklisp-to-nix-packages."cl-postgres";
       }));


  "dbd-mysql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."dbd-mysql" or (x: {}))
       (import ./quicklisp-to-nix-output/dbd-mysql.nix {
         inherit fetchurl;
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-mysql" = quicklisp-to-nix-packages."cl-mysql";
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
           "cl-aa" = quicklisp-to-nix-packages."cl-aa";
           "cl-fad" = quicklisp-to-nix-packages."cl-fad";
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
       }));


  "cl-who" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-who" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-who.nix {
         inherit fetchurl;
       }));


  "cl-vectors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-vectors" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-vectors.nix {
         inherit fetchurl;
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
       }));


  "cl-test-more" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-test-more" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-test-more.nix {
         inherit fetchurl;
       }));


  "cl-syntax-markup" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax-markup" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax-markup.nix {
         inherit fetchurl;
           "cl-markup" = quicklisp-to-nix-packages."cl-markup";
       }));


  "cl-syntax-anonfun" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax-anonfun" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax-anonfun.nix {
         inherit fetchurl;
           "cl-anonfun" = quicklisp-to-nix-packages."cl-anonfun";
       }));


  "cl-syntax-annot" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-syntax-annot" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-syntax-annot.nix {
         inherit fetchurl;
           "cl-annot" = quicklisp-to-nix-packages."cl-annot";
       }));


  "cl+ssl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl+ssl" or (x: {}))
       (import ./quicklisp-to-nix-output/cl+ssl.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-garbage" = quicklisp-to-nix-packages."trivial-garbage";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "clss" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clss" or (x: {}))
       (import ./quicklisp-to-nix-output/clss.nix {
         inherit fetchurl;
       }));


  "clsql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clsql" or (x: {}))
       (import ./quicklisp-to-nix-output/clsql.nix {
         inherit fetchurl;
           "uffi" = quicklisp-to-nix-packages."uffi";
       }));


  "cl-smtp" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-smtp" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-smtp.nix {
         inherit fetchurl;
           "cl+ssl" = quicklisp-to-nix-packages."cl+ssl";
           "cl-base64" = quicklisp-to-nix-packages."cl-base64";
           "flexi-streams" = quicklisp-to-nix-packages."flexi-streams";
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


  "cl-ppcre-unicode" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ppcre-unicode" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ppcre-unicode.nix {
         inherit fetchurl;
           "cl-unicode" = quicklisp-to-nix-packages."cl-unicode";
       }));


  "cl-ppcre-template" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-ppcre-template" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-ppcre-template.nix {
         inherit fetchurl;
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


  "cl-mysql" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-mysql" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-mysql.nix {
         inherit fetchurl;
           "cffi" = quicklisp-to-nix-packages."cffi";
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


  "cl-fuse-meta-fs" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-fuse-meta-fs" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-fuse-meta-fs.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
           "cl-fuse" = quicklisp-to-nix-packages."cl-fuse";
           "iterate" = quicklisp-to-nix-packages."iterate";
           "pcall" = quicklisp-to-nix-packages."pcall";
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


  "cl-emb" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-emb" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-emb.nix {
         inherit fetchurl;
       }));


  "cl-dbi" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-dbi" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-dbi.nix {
         inherit fetchurl;
       }));


  "cl-cookie" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-cookie" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-cookie.nix {
         inherit fetchurl;
           "quri" = quicklisp-to-nix-packages."quri";
           "proc-parse" = quicklisp-to-nix-packages."proc-parse";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "cl-colors" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-colors" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-colors.nix {
         inherit fetchurl;
           "alexandria" = quicklisp-to-nix-packages."alexandria";
           "let-plus" = quicklisp-to-nix-packages."let-plus";
       }));


  "cl-base64" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-base64" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-base64.nix {
         inherit fetchurl;
       }));


  "cl-async-ssl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async-ssl" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async-ssl.nix {
         inherit fetchurl;
           "vom" = quicklisp-to-nix-packages."vom";
           "cffi" = quicklisp-to-nix-packages."cffi";
       }));


  "cl-async-repl" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async-repl" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async-repl.nix {
         inherit fetchurl;
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "cl-async-base" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async-base" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async-base.nix {
         inherit fetchurl;
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "bordeaux-threads" = quicklisp-to-nix-packages."bordeaux-threads";
       }));


  "cl-async" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."cl-async" or (x: {}))
       (import ./quicklisp-to-nix-output/cl-async.nix {
         inherit fetchurl;
           "uiop" = quicklisp-to-nix-packages."uiop";
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "static-vectors" = quicklisp-to-nix-packages."static-vectors";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-libuv" = quicklisp-to-nix-packages."cl-libuv";
           "cl-async-util" = quicklisp-to-nix-packages."cl-async-util";
           "cl-async-base" = quicklisp-to-nix-packages."cl-async-base";
           "cffi" = quicklisp-to-nix-packages."cffi";
           "babel" = quicklisp-to-nix-packages."babel";
       }));


  "clack-v1-compat" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."clack-v1-compat" or (x: {}))
       (import ./quicklisp-to-nix-output/clack-v1-compat.nix {
         inherit fetchurl;
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
           "trivial-gray-streams" = quicklisp-to-nix-packages."trivial-gray-streams";
           "fast-io" = quicklisp-to-nix-packages."fast-io";
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
           "uiop" = quicklisp-to-nix-packages."uiop";
           "trivial-features" = quicklisp-to-nix-packages."trivial-features";
           "babel" = quicklisp-to-nix-packages."babel";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


  "caveman" = buildLispPackage
    ((f: x: (x // (f x)))
       (qlOverrides."caveman" or (x: {}))
       (import ./quicklisp-to-nix-output/caveman.nix {
         inherit fetchurl;
           "myway" = quicklisp-to-nix-packages."myway";
           "local-time" = quicklisp-to-nix-packages."local-time";
           "do-urlencode" = quicklisp-to-nix-packages."do-urlencode";
           "clack-v1-compat" = quicklisp-to-nix-packages."clack-v1-compat";
           "cl-syntax-annot" = quicklisp-to-nix-packages."cl-syntax-annot";
           "cl-syntax" = quicklisp-to-nix-packages."cl-syntax";
           "cl-project" = quicklisp-to-nix-packages."cl-project";
           "cl-ppcre" = quicklisp-to-nix-packages."cl-ppcre";
           "cl-emb" = quicklisp-to-nix-packages."cl-emb";
           "anaphora" = quicklisp-to-nix-packages."anaphora";
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
           "split-sequence" = quicklisp-to-nix-packages."split-sequence";
           "esrap" = quicklisp-to-nix-packages."esrap";
           "alexandria" = quicklisp-to-nix-packages."alexandria";
       }));


} // qlAliases {inherit quicklisp-to-nix-packages;};
qlAliases = import ./quicklisp-to-nix-aliases.nix;
in
   quicklisp-to-nix-packages
