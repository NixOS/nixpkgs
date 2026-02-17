{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "merge3";
  version = "0.0.16";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CFLeQ4HLRr5e9O1J46wgxaSgzUao/0u7hwvCeqtUMwY=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "merge3" ];

  meta = {
    description = "Python implementation of 3-way merge";
    mainProgram = "merge3";
    homepage = "https://github.com/breezy-team/merge3";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}
