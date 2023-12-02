{ lib
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, lxml
, poetry-core
, pytestCheckHook
, pythonOlder
, xmldiff
}:

buildPythonPackage rec {
  pname = "py-serializable";
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "madpah";
    repo = "serializable";
    rev = "refs/tags/v${version}";
    hash = "sha256-javjmdFQBxg/yqa6lsxKK18DgvVu/YmqvaWo2Upgzqs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    defusedxml
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
    xmldiff
  ];

  pythonImportsCheck = [
    "serializable"
  ];

  disabledTests = [
    # AssertionError: '<ns0[155 chars]itle>The Phoenix
    "test_serializable_no_defaultNS"
    "test_serializable_with_defaultNS"
  ];

  meta = with lib; {
    description = "Pythonic library to aid with serialisation and deserialisation to/from JSON and XML";
    homepage = "https://github.com/madpah/serializable";
    changelog = "https://github.com/madpah/serializable/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
