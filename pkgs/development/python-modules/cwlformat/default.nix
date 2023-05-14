{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "cwlformat";
  version = "2022.02.18";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rabix";
    repo = "cwl-format";
    rev = "refs/tags/${version}";
    hash = "sha256-FI8hUgb/KglTkubZ+StzptoSsYal71ITyyFNg7j48yk=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cwlformat"
  ];

  meta = with lib; {
    description = "Code formatter for CWL";
    homepage = "https://github.com/rabix/cwl-format";
    changelog = "https://github.com/rabix/cwl-format/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
