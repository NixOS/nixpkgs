{ lib, buildPythonPackage, fetchPypi, isPy27, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736";
  };

  propagatedBuildInputs = [ six ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Validate configuration and produce human readable error messages";
    homepage = "https://github.com/asottile/cfgv";
    license = licenses.mit;
  };
}
