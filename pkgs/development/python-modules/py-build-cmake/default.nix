{
  lib,
  fetchPypi,
  buildPythonPackage,
  pyproject-metadata,
  setuptools,
  distlib,
  packaging,
  tomli,
  lark,
  click,
}:

let
  version = "0.4.2";

  build-system = [
    distlib
    packaging
    tomli
    lark

    setuptools
    pyproject-metadata
  ];
in

buildPythonPackage {
  inherit version;
  pname = "py-build-cmake";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "py_build_cmake";
    hash = "sha256-AzAxm/VJPSldUdYK3rbmb4qx8N3ChPvY0LVAlHjssRE=";
  };

  patches = [
    ./0001-fix-relax-build-system-dependencies.patch
  ];

  inherit build-system;
  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = build-system ++ [
    click
  ];

  meta = {
    description = "A modern, PEP 517 compliant build backend for creating Python packages with extensions built using CMake.";
    homepage = "https://github.com/tttapa/py-build-cmake";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lach ];
  };
}
