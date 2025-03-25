{
  lib,
  attrs,
  bitarray,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyais";
  version = "2.9.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "M0r13n";
    repo = "pyais";
    tag = "v${version}";
    hash = "sha256-0W+bPYWbfXXbo7m7EizFYX00LdxYn1Iu46o0MgiX2Gk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    bitarray
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyais" ];

  disabledTestPaths = [
    # Tests the examples which have additional requirements
    "tests/test_examples.py"
  ];

  meta = with lib; {
    description = "Module for decoding and encoding AIS messages (AIVDM/AIVDO)";
    homepage = "https://github.com/M0r13n/pyais";
    changelog = "https://github.com/M0r13n/pyais/blob/${src.tag}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
