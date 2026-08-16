{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  packaging,
  setuptools-scm,
  vcs-versioning,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nipreps-versions";
  version = "1.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nipreps";
    repo = "version-schemes";
    tag = finalAttrs.version;
    hash = "sha256-SPJ4L68dFcSv1+Ytp3b3n+lr35Krq71fIlaReFux1nk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    packaging
    setuptools-scm
    vcs-versioning
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nipreps_versions" ];

  disabledTests = [
    # Rely on the current date, which is pinned to 1980 in the sandbox (`SOURCE_DATE_EPOCH`)
    "invalid_branch_version"
    "test_next_calver"
  ];

  meta = {
    description = "Setuptools_scm plugin for nipreps version schemes";
    homepage = "https://github.com/nipreps/version-schemes";
    changelog = "https://github.com/nipreps/version-schemes/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
