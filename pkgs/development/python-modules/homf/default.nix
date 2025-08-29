{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  # pytestCheckHook,
  pythonOlder,
  versionCheckHook,

  hatchling,
  packaging,
}:

buildPythonPackage rec {
  pname = "homf";
  version = "1.1.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = "homf";
    tag = "v${version}";
    hash = "sha256-fDH6uJ2d/Jsnuudv+Qlv1tr3slxOJWh7b4smGS32n9A=";
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
  # disabledTestMarks = [ "network" ];

  nativeBuildInputs = [ versionCheckHook ];

  # (Ab)using `callPackage` as a fix-point operator, so tests can use the `homf` drv
  passthru.tests = callPackage ./tests.nix { };

  meta = with lib; {
    description = "Asset download tool for GitHub Releases, PyPi, etc";
    mainProgram = "homf";
    homepage = "https://github.com/duckinator/homf";
    license = licenses.mit;
    maintainers = with maintainers; [ nicoo ];
  };
}
