{ stdenv, buildPythonPackage, fetchPypi
, pillow, tox, mock, six, nose, requests, decorator, simplejson }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bb4af836d7422a6138f983b81c16acd56c2d608913982602856cc273ae74768";
  };

  buildInputs = [ pillow tox mock six nose ];
  propagatedBuildInputs = [ requests decorator simplejson ];

  meta = with stdenv.lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = https://github.com/DataDog/datadogpy;
  };
}
