{ lib, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "aspy.yaml";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ajb97kn044ximkzq2090h4yblrhw77540pwiw345cp7mwzy4xqa";
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
