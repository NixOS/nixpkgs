{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  lib,
  more-itertools,
  psutil,
  pytestCheckHook,
  unzip,
}:

buildPythonPackage rec {
  pname = "datasalad";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalad";
    repo = "datasalad";
    rev = "refs/tags/v${version}";
    hash = "sha256-qgHWTokNBzJcBbEPCA/YfklzqyX1lM2yro7ElqBfrig=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
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
