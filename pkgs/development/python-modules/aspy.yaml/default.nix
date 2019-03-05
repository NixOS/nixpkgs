{ lib, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "aspy.yaml";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5eaaacd0886e8b581f0e4ff383fb6504720bb2b3c7be17307724246261a41adf";
  };

  propagatedBuildInputs = [ pyyaml ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "A few extensions to pyyaml";
    homepage = https://github.com/asottile/aspy.yaml;
    license = licenses.mit;
  };
}
