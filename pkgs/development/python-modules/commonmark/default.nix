{ lib, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, future }:

buildPythonPackage rec {
  pname = "CommonMark";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4dfbbd1dbc669a9b71a015032b2bbe5c4b019ca8b6ca410d89cf7020de46d2c0";
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
