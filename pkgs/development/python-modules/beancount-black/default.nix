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
  version = "0.1.13";

  disabled = pythonOlder "3.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-black";
    rev = version;
    sha256 = "sha256-jhcPR+5+e8d9cbcXC//xuBwmZ14xtXNlYtmH5yNSU0E=";
  };

  buildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    beancount-parser
    click
  ];

  checkInputs = [
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
