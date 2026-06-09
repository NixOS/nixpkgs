{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wcwidth,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "beautifultable";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pri22296";
    repo = "beautifultable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/SReCEvSwiNjBoz/3tGJ9zUNBAag4mLsHlUXwm47zCw=";
  };

  build-system = [ setuptools ];

  dependencies = [ wcwidth ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "beautifultable" ];

  meta = {
    description = "Python package for printing visually appealing tables";
    homepage = "https://github.com/pri22296/beautifultable";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
