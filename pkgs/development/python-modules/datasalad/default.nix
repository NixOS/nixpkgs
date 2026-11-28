{
  buildPythonPackage,
  fetchgit,
  hatchling,
  hatch-vcs,
  lib,
  gitMinimal,
  more-itertools,
  psutil,
  pytestCheckHook,
  unzip,
}:

buildPythonPackage (finalAttrs: {
  pname = "datasalad";
  version = "0.9.0";
  pyproject = true;

  src = fetchgit {
    url = "https://hub.datalad.org/datalad/datasalad.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yImgMl5HGWovnACCvgsDyetPoE2ubrZq0eZAddkF4Tk=";
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
    changelog = "https://hub.datalad.org/datalad/datasalad/src/branch/main/CHANGELOG.md";
    homepage = "https://hub.datalad.org/datalad/datasalad";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
})
