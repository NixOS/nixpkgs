{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, mdformat
, mdit-py-plugins
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-tables";
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Q61GmaRxjxJh9GjyR8QCZOH0njFUtAWihZ9lFQJ2nQQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  buildInputs = [
    mdformat
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mdformat_tables"
  ];

  meta = with lib; {
    description = "An mdformat plugin for rendering tables";
    homepage = "https://github.com/executablebooks/mdformat-tables";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero polarmutex ];
  };
}
