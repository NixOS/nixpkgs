{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  yasm,
}:

buildPythonPackage rec {
  pname = "distorm3";
  version = "3.5.2";
  pyproject = true;

  # Still uses distutils, https://github.com/gdabah/distorm/issues/191
  disabled = pythonOlder "3.5" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "gdabah";
    repo = "distorm";
    rev = "refs/tags/${version}";
    hash = "sha256-Fhvxag2UN5wXEySP1n1pCahMQR/SfssywikeLmiASwQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    yasm
  ];

  disabledTests = [
    # TypeError: __init__() missing 3 required positional...
    "test_dummy"
  ];

  pythonImportsCheck = [ "distorm3" ];

  meta = with lib; {
    description = "Disassembler library for x86/AMD64";
    homepage = "https://github.com/gdabah/distorm";
    changelog = "https://github.com/gdabah/distorm/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
