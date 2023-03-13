{ lib, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, future }:

buildPythonPackage rec {
  pname = "commonmark";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60";
  };

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  # UnicodeEncodeError on Python 2
  doCheck = isPy3k;

  nativeCheckInputs = [  glibcLocales ];
  propagatedBuildInputs = [ future ];

  meta = with lib; {
    description = "Python parser for the CommonMark Markdown spec";
    homepage = "https://github.com/rolandshoemaker/CommonMark-py";
    license = licenses.bsd3;
  };
}
