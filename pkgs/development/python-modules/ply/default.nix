{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "ply";
  version = "3.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3";
  };

  checkPhase = ''
    ${python.interpreter} test/testlex.py
    ${python.interpreter} test/testyacc.py
  '';

  # Test suite appears broken
  doCheck = false;

  meta = {
    homepage = "http://www.dabeaz.com/ply/";
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
