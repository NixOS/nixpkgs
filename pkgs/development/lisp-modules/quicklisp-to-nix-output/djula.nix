/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "djula";
  version = "20210124-git";

  description = "An implementation of Django templates for Common Lisp.";

  deps = [ args."access" args."alexandria" args."anaphora" args."arnesi" args."babel" args."cl-annot" args."cl-interpol" args."cl-locale" args."cl-ppcre" args."cl-slice" args."cl-syntax" args."cl-syntax-annot" args."cl-unicode" args."closer-mop" args."collectors" args."flexi-streams" args."gettext" args."iterate" args."let-plus" args."local-time" args."named-readtables" args."parser-combinators" args."split-sequence" args."symbol-munger" args."trivial-backtrace" args."trivial-features" args."trivial-gray-streams" args."trivial-types" args."yacc" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/djula/2021-01-24/djula-20210124-git.tgz";
    sha256 = "0hkyp5himz73r2l3vbwkwsd1as4f75ih6wh7v1wbabpbjwh2j2vx";
  };

  packageName = "djula";

  asdFilesToKeep = ["djula.asd"];
  overrides = x: x;
}
/* (SYSTEM djula DESCRIPTION
    An implementation of Django templates for Common Lisp. SHA256
    0hkyp5himz73r2l3vbwkwsd1as4f75ih6wh7v1wbabpbjwh2j2vx URL
    http://beta.quicklisp.org/archive/djula/2021-01-24/djula-20210124-git.tgz
    MD5 33ab6232122ccb88a53c51517b0c2bba NAME djula FILENAME djula DEPS
    ((NAME access FILENAME access) (NAME alexandria FILENAME alexandria)
     (NAME anaphora FILENAME anaphora) (NAME arnesi FILENAME arnesi)
     (NAME babel FILENAME babel) (NAME cl-annot FILENAME cl-annot)
     (NAME cl-interpol FILENAME cl-interpol)
     (NAME cl-locale FILENAME cl-locale) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-slice FILENAME cl-slice) (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME gettext FILENAME gettext) (NAME iterate FILENAME iterate)
     (NAME let-plus FILENAME let-plus) (NAME local-time FILENAME local-time)
     (NAME named-readtables FILENAME named-readtables)
     (NAME parser-combinators FILENAME parser-combinators)
     (NAME split-sequence FILENAME split-sequence)
     (NAME symbol-munger FILENAME symbol-munger)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-types FILENAME trivial-types) (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (access alexandria anaphora arnesi babel cl-annot cl-interpol cl-locale
     cl-ppcre cl-slice cl-syntax cl-syntax-annot cl-unicode closer-mop
     collectors flexi-streams gettext iterate let-plus local-time
     named-readtables parser-combinators split-sequence symbol-munger
     trivial-backtrace trivial-features trivial-gray-streams trivial-types
     yacc)
    VERSION 20210124-git SIBLINGS (djula-demo djula-test) PARASITES NIL) */
