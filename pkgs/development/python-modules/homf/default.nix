{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # pytestCheckHook,
  pythonOlder,

  hatchling,
  packaging,
}:

buildPythonPackage rec {
  pname = "homf";
  version = "1.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = "homf";
    rev = "refs/tags/v${version}";
    hash = "sha256-PU5VjBIVSMupTBh/qvVuZSFWpBbJOylCR02lONn9/qw=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "packaging" ];

  dependencies = [ packaging ];

  pythonImportsCheck = [
    "homf"
    "homf.api"
    "homf.api.github"
    "homf.api.pypi"
  ];

  # There are currently no checks which do not require network access, which breaks the check hook somehow?
  # nativeCheckInputs = [ pytestCheckHook ];
  # pytestFlagsArray = [ "-m 'not network'" ];

  meta = with lib; {
    description = "Asset download tool for GitHub Releases, PyPi, etc.";
    mainProgram = "homf";
    homepage = "https://github.com/duckinator/homf";
    license = licenses.mit;
    maintainers = with maintainers; [ nicoo ];
  };
}
