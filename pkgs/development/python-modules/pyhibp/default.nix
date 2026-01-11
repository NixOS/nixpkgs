{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyhibp";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitLab {
    group = "kitsunix";
    owner = "pyHIBP";
    repo = "pyHIBP";
    tag = "v${version}";
    hash = "sha256-2LJA989hpG5X6o+zCTSU0RRd0Z4zd29RAtp/jBW8Clo=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # All require internet access
    "TestIsPasswordBreached"
    "TestSuffixSearch"
    "TestGetAllBreaches"
    "TestGetSingleBreach"
    "TestGetDataClasses"
  ];

  pythonImportsCheck = [ "pyhibp" ];

  meta = {
    description = "Python interface to Troy Hunt's 'Have I Been Pwned?' public API";
    homepage = "https://gitlab.com/kitsunix/pyHIBP/pyHIBP";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
