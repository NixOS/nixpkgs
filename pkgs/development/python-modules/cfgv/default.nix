{ lib, buildPythonPackage, fetchPypi, isPy27, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8e8f552ffcc6194f4e18dd4f68d9aef0c0d58ae7e7be8c82bee3c5e9edfa513";
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
