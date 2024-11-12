{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # native
  poetry-core,

  # propagated
  blessed,
  editor,
  readchar,

  # tests
  pytest-mock,
  pytestCheckHook,
  pexpect,
}:

buildPythonPackage rec {
  pname = "inquirer";
  version = "3.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-inquirer";
    rev = "refs/tags/v${version}";
    hash = "sha256-vIW/rD22PFND9EPjS0YPbIauKgh9KHh1gXf1L8g/f10=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    blessed
    editor
    readchar
  ];

  nativeCheckInputs = [
    pexpect
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inquirer" ];

  meta = with lib; {
    description = "Collection of common interactive command line user interfaces, based on Inquirer.js";
    homepage = "https://github.com/magmax/python-inquirer";
    changelog = "https://github.com/magmax/python-inquirer/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
