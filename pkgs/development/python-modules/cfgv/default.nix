{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1akm5xdbi5kckgnhhfj6qavjwakm44cwqzhfx2ycgh7mkym1qyfi";
  };

  propagatedBuildInputs = [ six ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Validate configuration and produce human readable error messages";
    homepage = https://github.com/asottile/cfgv;
    license = licenses.mit;
  };
}
