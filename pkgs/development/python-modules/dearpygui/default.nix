{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  cmake,
  ninja,
  libX11,
  libXi,
  libXrandr,
  libXinerama,
  libXcursor,
  libGL,
  libXxf86vm,
  pkg-config,
  libxcrypt,
}:

buildPythonPackage rec {
  pname = "DearPyGui";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hoffstadt";
    repo = "DearPyGui";
    tag = "v${version}";
    hash = "sha256-gGZEEEFS8eK8Z3fTl0V7oN7BDQrDfRElozva7cV+0LA=";
    fetchSubmodules = true;
    deepClone = true;
  };

  build-system = [
    setuptools
    cmake
    ninja
    pkg-config
  ];

  dependencies = [
    libX11
    libXi
    libXrandr
    libXinerama
    libXcursor
    libGL
    libXxf86vm
    libxcrypt
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "dearpygui" ];

  meta = {
    description = "Graphical User Interface Toolkit for Python";
    homepage = "https://dearpygui.readthedocs.io/en/latest/";
    downloadPage = "https://github.com/hoffstadt/DearPyGui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
