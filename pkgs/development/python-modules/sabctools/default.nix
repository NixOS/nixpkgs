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
  version = "10.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uTlAvGO4r1XcmXOn4s8wddy4DaEDqVM50nDhIRN2raM=";
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
