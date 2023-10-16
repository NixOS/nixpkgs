{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, sure
}:

buildPythonPackage rec {
  pname = "py-partiql-parser";
  version = "0.3.8";
  pyproject = true;

  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "getmoto";
    repo = "py-partiql-parser";
    rev = "refs/tags/${version}";
    hash = "sha256-uIO06RRuUuE9qCEg/tTcn68i7vaFAAeFhxdxW9WAbuw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sure
  ];

  pythonImportsCheck = [
    "py_partiql_parser"
  ];

  meta = with lib; {
    description = "A tokenizer/parser/executor for the PartiQL-language";
    homepage = "https://github.com/getmoto/py-partiql-parser";
    changelog = "https://github.com/getmoto/py-partiql-parser/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
