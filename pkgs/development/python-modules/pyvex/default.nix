{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  bitstring,
  cffi,
  cmake,
  ninja,
  scikit-build-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvex";
  version = "10.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pyvex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-87UoNnucymq1XYlpHImF4LB3ExQP7kiabaPtIeHXfXc=";
    fetchSubmodules = true;
  };

  build-system = [
    scikit-build-core
  ];

  nativeBuildInputs = [
    cmake
    ninja
    cffi
  ];

  dependencies = [
    bitstring
    cffi
  ];

  # scikit-build-core owns the CMake configure/build lifecycle for the wheel.
  dontUseCmakeConfigure = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"scikit-build-core ~= 0.12.2"' '"scikit-build-core"'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace vex/Makefile-gcc \
      --replace-fail '/usr/bin/ar' 'ar'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyvex" ];

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
