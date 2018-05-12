{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "ply";
  version = "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8";
  };

  checkPhase = ''
    ${python.interpreter} test/testlex.py
    ${python.interpreter} test/testyacc.py
  '';

  # Test suite appears broken
  doCheck = false;

  meta = {
    homepage = http://www.dabeaz.com/ply/;
    description = "PLY (Python Lex-Yacc), an implementation of the lex and yacc parsing tools for Python";
    longDescription = ''
      PLY is an implementation of lex and yacc parsing tools for Python.
      In a nutshell, PLY is nothing more than a straightforward lex/yacc
      implementation.  Here is a list of its essential features: It's
      implemented entirely in Python; It uses LR-parsing which is
      reasonably efficient and well suited for larger grammars; PLY
      provides most of the standard lex/yacc features including support for
      empty productions, precedence rules, error recovery, and support for
      ambiguous grammars; PLY is straightforward to use and provides very
      extensive error checking; PLY doesn't try to do anything more or less
      than provide the basic lex/yacc functionality.  In other words, it's
      not a large parsing framework or a component of some larger system.
    '';
    license = lib.licenses.bsd3;
  };
}