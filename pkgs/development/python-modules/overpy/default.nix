{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "overpy";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DinoTools";
    repo = "python-overpy";
    tag = version;
    hash = "sha256-+bMpA4xDvnQl6Q0M2iGrsUHGLuR/gLimJgmZCMzsLvA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "overpy" ];

  meta = {
    description = "Python Wrapper to access the Overpass API";
    homepage = "https://github.com/DinoTools/python-overpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
}
