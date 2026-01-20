{
  lib,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  yasm,
}:

buildPythonPackage rec {
  pname = "distorm3";
  version = "3.5.2b";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdabah";
    repo = "distorm";
    tag = version;
    hash = "sha256-2ftEV3TMS3HT7f96k+Pwt3Mm31fVEXcHpcbbz05jycU=";
  };

  build-system = [
    distutils
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    yasm
  ];

  # TypeError: __init__() missing 3 required positional...
  doCheck = false;

  pythonImportsCheck = [ "distorm3" ];

  meta = {
    description = "Disassembler library for x86/AMD64";
    homepage = "https://github.com/gdabah/distorm";
    changelog = "https://github.com/gdabah/distorm/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
