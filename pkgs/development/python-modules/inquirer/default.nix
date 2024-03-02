{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# native
, poetry-core

# propagated
, blessed
, python-editor
, readchar

# tests
, pytest-mock
, pytestCheckHook
, pexpect
}:

buildPythonPackage rec {
  pname = "inquirer";
  version = "3.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub rec {
    owner = "magmax";
    repo = "python-inquirer";
    rev = "refs/tags/v${version}";
    hash = "sha256-1xaxLIk4GFRpcodhBX+Co9TgpYkWhB/D4OE4Nny4ijM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    blessed
    python-editor
    readchar
  ];

  nativeCheckInputs = [
    pexpect
    pytest-mock
    pytestCheckHook
  ];


  pythonImportsCheck = [
    "inquirer"
  ];

  meta = with lib; {
    description = "A collection of common interactive command line user interfaces, based on Inquirer.js";
    homepage = "https://github.com/magmax/python-inquirer";
    changelog = "https://github.com/magmax/python-inquirer/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
