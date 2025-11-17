{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  lxml,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  xmldiff,
}:

buildPythonPackage rec {
  pname = "py-serializable";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "madpah";
    repo = "serializable";
    tag = "v${version}";
    hash = "sha256-nou1/80t9d2iKOdZZbcN4SI3dlvuC8T55KMCP/cDEEU=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "defusedxml" ];

  dependencies = [ defusedxml ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
    xmldiff
  ];

  pythonImportsCheck = [ "py_serializable" ];

  disabledTests = [
    # AssertionError: '<ns0[155 chars]itle>The Phoenix
    "test_serializable_no_defaultNS"
    "test_serializable_with_defaultNS"
  ];

  meta = with lib; {
    description = "Library to aid with serialisation and deserialisation to/from JSON and XML";
    homepage = "https://github.com/madpah/serializable";
    changelog = "https://github.com/madpah/serializable/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
