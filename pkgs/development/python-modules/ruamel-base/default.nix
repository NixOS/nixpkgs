{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ruamel-base";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "ruamel.base";
    inherit version;
    sha256 = "1wswxrn4givsm917mfl39rafgadimf1sldpbjdjws00g1wx36hf0";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "ruamel.base" ];

  pythonNamespaces = [ "ruamel" ];

  meta = with lib; {
    description = "Common routines for ruamel packages";
    homepage = "https://sourceforge.net/projects/ruamel-base/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
