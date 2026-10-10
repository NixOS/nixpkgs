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
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pypcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qQgOtz8TRbP6LkGehSJM8ig6TsmwTz7gy8aA4dozwoc=";
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
