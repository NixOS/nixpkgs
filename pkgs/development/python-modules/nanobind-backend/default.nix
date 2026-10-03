{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,

  # build-system
  cmake,
  ninja,
  scikit-build-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "nanobind-backend";
  version = "1.0.0";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "wjakob";
    repo = "nanobind";
    tag = "v3.0.1";
    fetchSubmodules = true;
    hash = "sha256-VjH2cxjWctd99puD4U1ebnkQZaXF/t3ydtIHroV3BAI=";
  };

  sourceRoot = "${finalAttrs.src.name}/nanobind-backend";

  build-system = [
    cmake
    ninja
    scikit-build-core
  ];

  dontUseCmakeBuildDir = true;

  pythonImportsCheck = [
    "nanobind_backend"
    "nanobind_backend._nb_backend_v1"
  ];

  meta = {
    description = "Compiled nanobind backend for extensions built in split mode";
    homepage = "https://github.com/wjakob/nanobind";
    changelog = "https://github.com/wjakob/nanobind/blob/v3.0.1/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ parras ];
  };
})
