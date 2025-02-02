{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pybind11,
  pytestCheckHook,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mapbox-earcut";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skogler";
    repo = "mapbox_earcut_python";
    rev = "refs/tags/v${version}";
    hash = "sha256-+Vxvo++bkoCsJFmt/u1eaqhgpz8Uddz06iIi66ju+MQ=";
  };

  nativeBuildInputs = [
    setuptools
    pybind11
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mapbox_earcut" ];

  meta = with lib; {
    homepage = "https://github.com/skogler/mapbox_earcut_python";
    changelog = "https://github.com/skogler/mapbox_earcut_python/releases/tag/v${version}";
    license = licenses.isc;
    description = "Mapbox-earcut fast triangulation of 2D-polygons";
    longDescription = ''
      Python bindings for the C++ implementation of the Mapbox Earcut
      library, which provides very fast and quite robust triangulation of 2D
      polygons.
    '';
    maintainers = with maintainers; [ friedelino ];
  };
}
