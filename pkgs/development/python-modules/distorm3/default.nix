{
  lib,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  yasm,
}:

buildPythonPackage rec {
  pname = "distorm3";
  version = "3.5.2b";
  pyproject = true;

  disabled = pythonOlder "3.5";

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

<<<<<<< HEAD
  meta = {
    description = "Disassembler library for x86/AMD64";
    homepage = "https://github.com/gdabah/distorm";
    changelog = "https://github.com/gdabah/distorm/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Disassembler library for x86/AMD64";
    homepage = "https://github.com/gdabah/distorm";
    changelog = "https://github.com/gdabah/distorm/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
