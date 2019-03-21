{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01mpw8kx0f2py2jwf0fv60k01p11gs0dbar5zq42k4z38xf0bn9r";
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
