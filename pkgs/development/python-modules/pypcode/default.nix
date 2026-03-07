{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  nanobind,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypcode";
  version = "3.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pypcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m3Ee1n6TIbcihTwz1ihpn10gC1YsSlFO17Gj0QVya2A=";
  };

  build-system = [
    cmake
    setuptools
    nanobind
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pypcode" ];

  preCheck = ''
    cd ..
  '';

  meta = {
    description = "Machine code disassembly and IR translation library";
    homepage = "https://github.com/angr/pypcode";
    license = with lib.licenses; [
      bsd2
      asl20
      zlib
    ];
    maintainers = with lib.maintainers; [ feyorsh ];
  };
})
