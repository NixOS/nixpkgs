{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "datauri";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fcurella";
    repo = "python-datauri";
    rev = "refs/tags/v${version}";
    hash = "sha256-+R1J4IjJ+Vf/+V2kiZyIyAqTAgGLTMJjGePyVRuO5rs=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "datauri" ];

  disabledTests = [
    # Test is incompatible with pydantic >=2
    "test_pydantic"
  ];

  meta = with lib; {
    description = "Module for Data URI manipulation";
    homepage = "https://github.com/fcurella/python-datauri";
    changelog = "https://github.com/fcurella/python-datauri/releases/tag/v${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ yuu ];
  };
}
