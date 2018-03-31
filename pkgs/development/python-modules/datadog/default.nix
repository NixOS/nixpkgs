{ stdenv, buildPythonPackage, fetchPypi
, pillow, tox, mock, six, nose, requests, decorator, simplejson }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y2if4jj43n5jis20imragvhhyhr840w4m1g7j7fxh9bn7h273zp";
  };

  buildInputs = [ pillow tox mock six nose ];
  propagatedBuildInputs = [ requests decorator simplejson ];

  meta = with stdenv.lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = https://github.com/DataDog/datadogpy;
  };
}
