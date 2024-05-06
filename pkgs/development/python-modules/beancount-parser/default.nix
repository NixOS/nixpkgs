{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, lark
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "beancount-parser";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-parser";
    rev = "refs/tags/${version}";
    hash = "sha256-uZcaIKlrHNJFt7dLBeaVgaNP8n+/79MwxK5oY1OxKNo=";
  };

  buildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    lark
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beancount_parser"
  ];

  meta = with lib; {
    description = "Standalone Lark based Beancount syntax parser";
    homepage = "https://github.com/LaunchPlatform/beancount-parser/";
    changelog = "https://github.com/LaunchPlatform/beancount-parser/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ambroisie ];
  };
}
