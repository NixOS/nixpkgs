{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "overpy";
  version = "0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DinoTools";
    repo = "python-overpy";
    tag = version;
    hash = "sha256-+bMpA4xDvnQl6Q0M2iGrsUHGLuR/gLimJgmZCMzsLvA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "overpy" ];

  meta = with lib; {
    description = "Python Wrapper to access the Overpass API";
    homepage = "https://github.com/DinoTools/python-overpy";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
