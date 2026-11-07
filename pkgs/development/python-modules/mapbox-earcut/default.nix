{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  nanobind,
  scikit-build-core,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mapbox-earcut";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skogler";
    repo = "mapbox_earcut_python";
    tag = "v${version}";
    hash = "sha256-fHUbmCo+r9IkP7PuAgxf7bu7lUFItjgAJprc6B2rGqU=";
  };

  build-system = [
    nanobind
    scikit-build-core
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf mapbox_earcut
  '';

  pythonImportsCheck = [ "mapbox_earcut" ];

  meta = {
    homepage = "https://github.com/skogler/mapbox_earcut_python";
    changelog = "https://github.com/skogler/mapbox_earcut_python/releases/tag/${src.tag}";
    license = lib.licenses.isc;
    description = "Mapbox-earcut fast triangulation of 2D-polygons";
    longDescription = ''
      Python bindings for the C++ implementation of the Mapbox Earcut
      library, which provides very fast and quite robust triangulation of 2D
      polygons.
    '';
    maintainers = [ ];
  };
}
