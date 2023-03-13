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
  version = "0.1.23";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-parser";
    rev = "refs/tags/${version}";
    hash = "sha256-3pO1HvH3R2RpNFtplWyaXxqZy0caAoAxlmfSKmjkvKQ=";
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
