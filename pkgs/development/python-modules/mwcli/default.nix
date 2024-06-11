{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  docopt,
  para,
}:

buildPythonPackage rec {
  pname = "mwcli";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ADMb0P8WtXIcnGJ02R4l/TVfRewHc8ig45JurAWHGaA=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "mwxml" ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    docopt
    para
  ];

  # Tests require mwxml which itself depends on this package (circular dependency)
  doCheck = false;

  meta = with lib; {
    description = "Set of helper functions and classes for mediawiki-utilities command-line utilities";
    homepage = "https://github.com/mediawiki-utilities/python-mwcli";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
