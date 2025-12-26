{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sabnzbd,
}:
buildPythonPackage rec {
  pname = "sabctools";
  version = "9.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i4xplGc85ZuJLvA6oRocHY3sw1UMt7S2bIkwMUDunEk=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "sabctools" ];

  passthru.tests = {
    inherit sabnzbd;
  };

  meta = {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ adamcstephens ];
  };
}
