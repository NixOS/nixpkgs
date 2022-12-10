{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "derpconf";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bb152d8a1cf5c2a6d629bf29acd4af0c00811339642fc0a56172b0a83b31a15";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "derpconf abstracts loading configuration files for your app";
    homepage = "https://github.com/globocom/derpconf";
    license = licenses.mit;
  };
}
