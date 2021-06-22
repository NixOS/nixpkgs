{ lib, buildPythonPackage, fetchPypi, isPy27, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e600479b3b99e8af981ecdfc80a0296104ee610cab48a5ae4ffd0b668650eb1";
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
