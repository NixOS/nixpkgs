{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pytestCheckHook
, pythonOlder
, pytz
, typing-extensions
}:

buildPythonPackage rec {
  pname = "dirty-equals";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yYptO6NPhQRlF0T2eXliw2WBms9uqTZVzdYzGj9pCug=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pytz
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dirty_equals"
  ];

  meta = with lib; {
    description = "Module for doing dirty (but extremely useful) things with equals";
    homepage = "https://github.com/samuelcolvin/dirty-equals";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
