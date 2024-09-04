{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  hatchling,
  sure,
}:

buildPythonPackage rec {
  pname = "py-partiql-parser";
  version = "0.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "getmoto";
    repo = "py-partiql-parser";
    rev = "refs/tags/${version}";
    hash = "sha256-BSqc3xibStb3J6Rua4dDp/eRD5/ns/dU1vGa4vL1Cyo=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    sure
  ];

  pythonImportsCheck = [ "py_partiql_parser" ];

  meta = with lib; {
    description = "Tokenizer/parser/executor for the PartiQL-language";
    homepage = "https://github.com/getmoto/py-partiql-parser";
    changelog = "https://github.com/getmoto/py-partiql-parser/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
