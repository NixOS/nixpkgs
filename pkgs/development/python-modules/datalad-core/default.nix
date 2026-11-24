{
  buildPythonPackage,
  lib,
  hatchling,
  hatch-vcs,
  datasalad,
  datalad,
  looseversion,
  more-itertools,
  fetchgit,
  git,
  git-annex,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "datalad-core";
  version = "0.3.0";
  pyproject = true;

  src = fetchgit {
    url = "https://hub.datalad.org/datalad/datalad-core.git";
    # no v0.3.0 tag
    rev = "4b316b571b2ed6a0e6c4fd4f818170f37786b2f7";
    hash = "sha256-+87pMoHFv1630jwumTQ9FcERNpXlOmGSyFvgau1EblI=";
  };

  nativeBuildInputs = [
    git
  ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    datasalad
    looseversion
    more-itertools
    datalad
  ];

  optional-dependencies = {
    annex = [ git-annex ];
  };

  disabledTests = [
    "test_call_annex_json_lines"
    "test_call_git_oneline"
  ];

  nativeCheckInputs = [
    datasalad
    pytestCheckHook
    git-annex
  ];

  pythonImportsCheck = [ "datalad_core" ];

  meta = {
    description = "Core library for the datalad-framework";
    homepage = "https://www.datalad.org";
    changelog = "https://hub.datalad.org/datalad/datalad-core/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gador
    ];
  };
})
