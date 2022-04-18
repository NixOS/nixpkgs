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
  version = "0.1.21";

  disabled = pythonOlder "3.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-parser";
    rev = version;
    sha256 = "sha256-0uhH75OEjC9iA0XD0VX7CGoRIP/hpM4y+53JnyXgZpA=";
  };

  buildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    lark
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beancount_parser"
  ];

  meta = with lib; {
    description = "Standalone Lark based Beancount syntax parser";
    homepage = "https://github.com/LaunchPlatform/beancount-parser/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ambroisie ];
  };
}
