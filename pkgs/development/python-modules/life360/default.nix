{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "life360";
  version = "7.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pnbruckner";
    repo = "life360";
    rev = "refs/tags/v${version}";
    hash = "sha256-GkCs479lXcnCvb5guxyc+ZuZdiH4n8uD2VbkC+yijgg=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "life360" ];

  meta = with lib; {
    description = "Module to interact with Life360";
    homepage = "https://github.com/pnbruckner/life360";
    changelog = "https://github.com/pnbruckner/life360/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
