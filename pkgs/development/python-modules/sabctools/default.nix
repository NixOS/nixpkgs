{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sabnzbd,
}:
buildPythonPackage rec {
  pname = "sabctools";
  version = "9.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lYs0ve17IfDs3OccKweun/J+Sl5ct/HFVHwwEZP2LNk=";
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
