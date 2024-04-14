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
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "madpah";
    repo = "serializable";
    rev = "refs/tags/v${version}";
    hash = "sha256-oVjb7/9RWvQd5L6xQBrspfblPzMaRvnZHDuojTuq+zE=";
  };

  build-system = [ poetry-core ];

  dependencies = [ defusedxml ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
    xmldiff
  ];

  pythonImportsCheck = [ "serializable" ];

  disabledTests = [
    # AssertionError: '<ns0[155 chars]itle>The Phoenix
    "test_serializable_no_defaultNS"
    "test_serializable_with_defaultNS"
  ];

  meta = with lib; {
    description = "Library to aid with serialisation and deserialisation to/from JSON and XML";
    homepage = "https://github.com/madpah/serializable";
    changelog = "https://github.com/madpah/serializable/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
