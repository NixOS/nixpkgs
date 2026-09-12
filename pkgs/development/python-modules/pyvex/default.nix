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
  # Keep angr-management, angr, archinfo, claripy, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "9.3.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyvex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MXWZt+l2hkRxoE8kTtKm+B2gXy+e2oBZ6PNyfUuq6Rs=";
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

  # pythonRelaxDeps cannot relax build-system requirements.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'scikit-build-core ~= 0.12.2' 'scikit-build-core'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
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
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
