{ lib, buildPythonPackage, fetchPypi, isPy27, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf22deb93d4bcf92f345a5c3cd39d3d41d6340adc60c78bbbd6588c384fda6a1";
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
