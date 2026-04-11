{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  wcwidth,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "beautifultable";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pri22296";
    repo = "beautifultable";
    rev = "v${version}";
    hash = "sha256-/SReCEvSwiNjBoz/3tGJ9zUNBAag4mLsHlUXwm47zCw=";
  };

  propagatedBuildInputs = [ wcwidth ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "beautifultable" ];

  meta = {
    description = "Python package for printing visually appealing tables";
    homepage = "https://github.com/pri22296/beautifultable";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
