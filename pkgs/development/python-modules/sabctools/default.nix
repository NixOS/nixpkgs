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
  version = "10.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q9J7Y7O1W7HBA5nO5TpYY9+iofoceU7WKBjY34Nhqaw=";
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
