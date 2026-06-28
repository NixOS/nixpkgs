{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sabnzbd,
}:

buildPythonPackage rec {
  pname = "sabctools";
  version = "9.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x0+9GT/xs+EdX63qglTeuYE/z8cp/kOZmk6zd8MlAgQ=";
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
