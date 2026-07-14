{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sabnzbd,
}:

buildPythonPackage rec {
  pname = "sabctools";
  version = "9.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7hiLzmhaB5btSw5OVWcGpWAvsnKKamybRvwDQMrdigM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "sabctools" ];

  passthru.tests = {
    inherit sabnzbd;
  };

  meta = {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    changelog = "https://github.com/sabnzbd/sabctools/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ adamcstephens ];
  };
}
