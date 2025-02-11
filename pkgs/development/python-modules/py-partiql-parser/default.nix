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
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "getmoto";
    repo = "py-partiql-parser";
    tag = version;
    hash = "sha256-2qCGNRoeMRe5fPzoWFD9umZgUDW6by7jNfO/BByQGwE=";
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
    changelog = "https://github.com/getmoto/py-partiql-parser/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
