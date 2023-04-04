/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parser_dot_common-rules";
  version = "20200715-git";

  parasites = [ "parser.common-rules/test" ];

  description = "Provides common parsing rules that are useful in many grammars.";

  deps = [ args."alexandria" args."anaphora" args."esrap" args."fiveam" args."let-plus" args."split-sequence" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/parser.common-rules/2020-07-15/parser.common-rules-20200715-git.tgz";
    sha256 = "17nw0shhb8079b26ldwpfxggkzs6ysfqm4s4nr1rfhba9mkvxdxy";
  };

  packageName = "parser.common-rules";

  asdFilesToKeep = ["parser.common-rules.asd"];
  overrides = x: x;
}
/* (SYSTEM parser.common-rules DESCRIPTION
    Provides common parsing rules that are useful in many grammars. SHA256
    17nw0shhb8079b26ldwpfxggkzs6ysfqm4s4nr1rfhba9mkvxdxy URL
    http://beta.quicklisp.org/archive/parser.common-rules/2020-07-15/parser.common-rules-20200715-git.tgz
    MD5 6391d962ae6fc13cc57312de013504c5 NAME parser.common-rules FILENAME
    parser_dot_common-rules DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME esrap FILENAME esrap) (NAME fiveam FILENAME fiveam)
     (NAME let-plus FILENAME let-plus)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES
    (alexandria anaphora esrap fiveam let-plus split-sequence
     trivial-with-current-source-form)
    VERSION 20200715-git SIBLINGS (parser.common-rules.operators) PARASITES
    (parser.common-rules/test)) */
