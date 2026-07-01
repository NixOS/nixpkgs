{
  lib,
  stdenv,
  bitstring,
  buildPythonPackage,
  buildPackages,
  cffi,
  fetchFromGitHub,
  pycparser,
  setuptools,
  scikit-build-core,
  cmake,
  ninja,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvex";
  version = "9.2.197";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyvex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FRt+tCQLK2GFIwgCvUoRmxPGBryceJ+62tSK9WLMKQk=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    scikit-build-core
  ];

  dependencies = [
    bitstring
    cffi
    pycparser
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    cffi
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace vex/Makefile-gcc \
      --replace-fail '/usr/bin/ar' 'ar'
  '';

  setupPyBuildFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--plat-name"
    "linux"
  ];

  preBuild = ''
    export CC=${stdenv.cc.targetPrefix}cc
  '';

  pythonImportsCheck = [ "pyvex" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python interface to libVEX and VEX IR";
    homepage = "https://github.com/angr/pyvex";
    license = with lib.licenses; [
      bsd2
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
