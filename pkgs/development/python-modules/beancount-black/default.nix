{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, beancount-parser
, click
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "beancount-black";
  version = "0.2.1";

  disabled = pythonOlder "3.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-black";
    rev = version;
    hash = "sha256-wvAQnwnyHn5Koc/UN4zpJ3JDmFbDoUrpCTmJCpSP7Mg=";
  };

  buildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    beancount-parser
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beancount_black"
  ];

  meta = with lib; {
    description = "Opinioned code formatter for Beancount";
    homepage = "https://github.com/LaunchPlatform/beancount-black/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ambroisie ];
  };
}
