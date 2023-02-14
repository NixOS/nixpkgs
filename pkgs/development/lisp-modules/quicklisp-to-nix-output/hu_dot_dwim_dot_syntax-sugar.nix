/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_syntax-sugar";
  version = "20161204-darcs";

  parasites = [ "hu.dwim.syntax-sugar/lambda-with-bang-args" ];

  description = "Various syntax extensions.";

  deps = [ args."alexandria" args."anaphora" args."closer-mop" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_common-lisp" args."hu_dot_dwim_dot_walker" args."iterate" args."metabang-bind" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.syntax-sugar/2016-12-04/hu.dwim.syntax-sugar-20161204-darcs.tgz";
    sha256 = "1ywzqp73aqvb9ah7g8vj2a29rfbdc0mba9amwjvnrgb29yxv7bsk";
  };

  packageName = "hu.dwim.syntax-sugar";

  asdFilesToKeep = ["hu.dwim.syntax-sugar.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.syntax-sugar DESCRIPTION Various syntax extensions. SHA256
    1ywzqp73aqvb9ah7g8vj2a29rfbdc0mba9amwjvnrgb29yxv7bsk URL
    http://beta.quicklisp.org/archive/hu.dwim.syntax-sugar/2016-12-04/hu.dwim.syntax-sugar-20161204-darcs.tgz
    MD5 c155225d3a2b9a329adfcb705b915a91 NAME hu.dwim.syntax-sugar FILENAME
    hu_dot_dwim_dot_syntax-sugar DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME closer-mop FILENAME closer-mop)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.common FILENAME hu_dot_dwim_dot_common)
     (NAME hu.dwim.common-lisp FILENAME hu_dot_dwim_dot_common-lisp)
     (NAME hu.dwim.walker FILENAME hu_dot_dwim_dot_walker)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind))
    DEPENDENCIES
    (alexandria anaphora closer-mop hu.dwim.asdf hu.dwim.common
     hu.dwim.common-lisp hu.dwim.walker iterate metabang-bind)
    VERSION 20161204-darcs SIBLINGS
    (hu.dwim.syntax-sugar.documentation hu.dwim.syntax-sugar.test) PARASITES
    (hu.dwim.syntax-sugar/lambda-with-bang-args)) */
