{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  joblib,
  nibabel,
  numpy,
  pandas,
  requests,
  scikit-learn,
  jinja2,
  scipy,
  packaging,

  pytestCheckHook,
  pytest-timeout,
  pytest-rerunfailures,
  numpydoc,
  polars,
}:

buildPythonPackage (finalAttrs: {
  pname = "nilearn";
  version = "0.14.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nilearn";
    repo = "nilearn";
    tag = finalAttrs.version;
    hash = "sha256-WG+ijSNur7XWF3D+MwQU/VUcMalKEEMkFtH0Meca+Mk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --template=maint_tools/templates/index.html" ""
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  # nilearn excludes scikit-learn 1.9.0 due to a sluggish HTML repr bug,
  # which is fixed by the patch applied to python3Packages.scikit-learn.
  pythonRelaxDeps = [
    "scikit-learn"
  ];

  dependencies = [
    joblib
    nibabel
    numpy
    pandas
    requests
    scikit-learn
    jinja2
    scipy
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
    pytest-rerunfailures
    numpydoc
    polars
  ];

  # do subset of tests which don't fetch resources
  enabledTestPaths = [ "nilearn/connectome/tests" ];

  meta = {
    description = "Module for statistical learning on neuroimaging data";
    homepage = "https://nilearn.github.io";
    changelog = "https://github.com/nilearn/nilearn/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
