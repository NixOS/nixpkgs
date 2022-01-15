{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "limits";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c0a57b42647f1141f5a7a0a8479b49e4367c24937a01bd9d4063a595c2dd48a";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false; # ifilter

  meta = with lib; {
    description = "Rate limiting utilities";
    license = licenses.mit;
    homepage = "https://limits.readthedocs.org/";
  };
}
