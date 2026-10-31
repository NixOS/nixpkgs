{
  lib,
  stdenv,
  bitstring,
  buildPythonPackage,
  buildPackages,
  cffi,
  cmake,
  fetchFromGitHub,
  ninja,
  pytestCheckHook,
  pythonOlder,
  scikit-build-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvex";
  # Keep angr-management, angr, archinfo, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "10.0.4";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyvex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3w7A9xYSYHh/o1JXpUllR4aUrW2MdUVdDR1ua7/gpCU=";
    fetchSubmodules = true;
  };

  build-system = [
    cffi
    scikit-build-core
  ];

  dependencies = [
    bitstring
    cffi
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace vex/Makefile-gcc \
      --replace-fail '/usr/bin/ar' 'ar'
  '';

  preBuild = ''
    export CC=${stdenv.cc.targetPrefix}cc
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyvex" ];

  meta = {
    description = "Python interface to libVEX and VEX IR";
    homepage = "https://github.com/angr/pyvex";
    license = with lib.licenses; [
      bsd2
      gpl3Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [
      connornelson
      fab
    ];
  };
})
