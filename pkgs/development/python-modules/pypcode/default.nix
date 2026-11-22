{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  nanobind,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypcode";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pypcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G0RMZJBAhKUVTMqyRBwJ5782uWVCst9RYvzfJLKJAgc=";
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
    maintainers = with lib.maintainers; [
      connornelson
    ];
  };
})
