{ lib, buildPythonPackage, fetchPypi, flake8, glibcLocales, future }:

buildPythonPackage rec {
  pname = "CommonMark";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee5a88f23678794592efe3fc11033f17fc77b3296a85f5e1d5b715f8e110a773";
  };

  LC_ALL="en_US.UTF-8";

  doCheck = false;

  buildInputs = [ flake8 glibcLocales ];
  propagatedBuildInputs = [ future ];

  meta = with lib; {
    description = "Python parser for the CommonMark Markdown spec";
    homepage = https://github.com/rolandshoemaker/CommonMark-py;
    license = licenses.bsd3;
  };
}
