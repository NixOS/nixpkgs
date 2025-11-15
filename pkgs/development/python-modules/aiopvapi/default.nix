{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiopvapi";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sander76";
    repo = "aio-powerview-api";
    tag = "v${version}";
    hash = "sha256-yystaH2HRsJoYh2aTpOBA7DLiC2xwpBUccHwmJ0FlaY=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiopvapi" ];

  disabledTests = [
    # AssertionError
    "test_remove_shade_from_scene"
  ];

  meta = with lib; {
    description = "Python API for the PowerView API";
    homepage = "https://github.com/sander76/aio-powerview-api";
    changelog = "https://github.com/sander76/aio-powerview-api/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
