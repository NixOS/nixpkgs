{ lib, buildPythonPackage, fetchPypi, isPy3k, werkzeug, twisted }:

buildPythonPackage rec {
  pname = "klein";
  version = "15.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hl2psnn1chm698rimyn9dgcpl1mxgc8dj11b3ipp8z37yfjs3z9";
  };

  disabled = isPy3k;

  propagatedBuildInputs = [ werkzeug twisted ];

  meta = with lib; {
    description = "Klein Web Micro-Framework";
    homepage    = "https://github.com/twisted/klein";
    license     = licenses.mit;
  };
}
