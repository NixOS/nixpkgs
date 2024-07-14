{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  glibcLocales,
  future,
}:

buildPythonPackage rec {
  pname = "commonmark";
  version = "0.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RS+dyFm+fwZjHdyzKLaRnGeYSsplTl/vs5FNVGka7WA=";
  };

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  # UnicodeEncodeError on Python 2
  doCheck = isPy3k;

  nativeCheckInputs = [ glibcLocales ];
  propagatedBuildInputs = [ future ];

  meta = with lib; {
    description = "Python parser for the CommonMark Markdown spec";
    mainProgram = "cmark";
    homepage = "https://github.com/rolandshoemaker/CommonMark-py";
    license = licenses.bsd3;
  };
}
