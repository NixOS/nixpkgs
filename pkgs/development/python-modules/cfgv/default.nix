{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zn3nc7cyfsvg9gp7558656n2sn1m01j30l79ci22ibgvq4vxv9j";
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
