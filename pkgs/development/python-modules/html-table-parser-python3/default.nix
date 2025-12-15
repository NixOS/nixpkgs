{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "html-table-parser-python3";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "schmijos";
    repo = "html-table-parser-python3";
    rev = "v${version}";
    hash = "sha256-okYl0T12wVld7GVbFQH2hgEVKXSScipJN/vYaiRVdGY=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "html_table_parser" ];

  meta = {
    description = "Small and simple HTML table parser not requiring any external dependency";
    homepage = "https://github.com/schmijos/html-table-parser-python3";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
