{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  cmake,
  ninja,
  libx11, # libX11 is now libx11
  libxi,
  libxrandr,
  libxinerama,
  libxcursor,
  libGL,
  libxxf86vm,
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
    hash = "sha256-tSy379ozrbTkI2kdnsBUbrUSZPNbojcWenK70pH3LVU=";
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
    libx11
    libxi
    libxrandr
    libxinerama
    libxcursor
    libGL
    libxxf86vm
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
