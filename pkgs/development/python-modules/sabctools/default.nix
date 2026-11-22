{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  ninja,
  scikit-build-core,
  sabnzbd,
}:

buildPythonPackage rec {
  pname = "sabctools";
  version = "9.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vAxV9WipR6n8oQp4XPwIZ+2vUlZbGzZTKal3aZYpz0s=";
  };

  build-system = [
    cmake
    ninja
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "sabctools" ];

  passthru.tests = {
    inherit sabnzbd;
  };

  meta = {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    changelog = "https://github.com/sabnzbd/sabctools/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
