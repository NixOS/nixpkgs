{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  lib,
  gitMinimal,
  more-itertools,
  psutil,
  pytestCheckHook,
  unzip,
}:

buildPythonPackage rec {
  pname = "datasalad";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalad";
    repo = "datasalad";
    tag = "v${version}";
    hash = "sha256-w00QY6oz0FgfgdY3f+mVRRnsOT0WJZV64ymgsXAINac=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
    more-itertools
    psutil
    unzip
  ];

  pythonImportsCheck = [ "datasalad" ];

  meta = {
    description = "Pure-Python library with a collection of utilities for working with Git and git-annex";
    changelog = "https://github.com/datalad/datasalad/blob/main/CHANGELOG.md";
    homepage = "https://github.com/datalad/datasalad";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
}
