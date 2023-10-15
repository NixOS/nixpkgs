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
  version = "0.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "madpah";
    repo = "serializable";
    rev = "refs/tags/v${version}";
    hash = "sha256-U01XRT6XS0Uxpk+2pYOGAkZiZ5kogMBtcuEU1OJpSMo=";
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

  meta = with lib; {
    description = "Pythonic library to aid with serialisation and deserialisation to/from JSON and XML";
    homepage = "https://github.com/madpah/serializable";
    changelog = "https://github.com/madpah/serializable/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
