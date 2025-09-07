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
  version = "3.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-inquirer";
    tag = "v${version}";
    hash = "sha256-xVHmdJGN5yOxbEkZIiOLqeUwcfdj+o7jTTWBD75szII=";
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
    changelog = "https://github.com/magmax/python-inquirer/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
