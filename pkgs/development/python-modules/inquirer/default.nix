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
  version = "3.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub rec {
    owner = "magmax";
    repo = "python-inquirer";
    rev = "refs/tags/v${version}";
    hash = "sha256-7kq0sZzPeCX7TA5Cl2rg6Uw+9jLz335a+tOrO0+Cyas=";
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
