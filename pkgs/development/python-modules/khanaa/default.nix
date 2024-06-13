{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pythonOlder,

  unittestCheckHook,

  setuptools,
}:

buildPythonPackage rec {
  pname = "khanaa";
  version = "0.0.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cakimpei";
    repo = "khanaa";
    rev = "refs/tags/v${version}";
    hash = "sha256-BzxNHYMkp5pdJYQ80EI5jlP654yX9woW7wz1jArCln4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "khanaa" ];

  meta = with lib; {
    description = "Tool to make spelling Thai more convenient";
    homepage = "https://github.com/cakimpei/khanaa";
    changelog = "https://github.com/cakimpei/khanaa/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
