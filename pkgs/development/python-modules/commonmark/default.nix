{ lib, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, future }:

buildPythonPackage rec {
  pname = "commonmark";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abcbc854e0eae5deaf52ae5e328501b78b4a0758bf98ac8bb792fce993006084";
  };

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  # UnicodeEncodeError on Python 2
  doCheck = isPy3k;

  checkInputs = [  glibcLocales ];
  propagatedBuildInputs = [ future ];

  meta = with lib; {
    description = "Python parser for the CommonMark Markdown spec";
    homepage = https://github.com/rolandshoemaker/CommonMark-py;
    license = licenses.bsd3;
  };
}
