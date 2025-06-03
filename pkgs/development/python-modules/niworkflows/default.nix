{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  acres,
  attrs,
  importlib-resources,
  jinja2,
  looseversion,
  matplotlib,
  nibabel,
  nilearn,
  nipype,
  nitransforms,
  numpy,
  packaging,
  pandas,
  pybids,
  pyyaml,
  scikit-image,
  scipy,
  seaborn,
  svgutils,
  templateflow,
  traits,
  transforms3d,

  # tests
  pytest-cov-stub,
  pytest-env,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "niworkflows";
  version = "1.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipreps";
    repo = "niworkflows";
    tag = version;
    hash = "sha256-rgnfp12SHlL3LFFMSrHlTd0tWNnA4ekxZ9kKYRvZWlw=";
  };

  pythonRelaxDeps = [ "traits" ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    acres
    attrs
    importlib-resources
    jinja2
    looseversion
    matplotlib
    nibabel
    nilearn
    nipype
    nitransforms
    numpy
    packaging
    pandas
    pybids
    pyyaml
    scikit-image
    scipy
    seaborn
    svgutils
    templateflow
    traits
    transforms3d
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-env
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlagsArray = [ "niworkflows" ];

  disabledTests = [
    # try to download data:
    "ROIsPlot"
    "ROIsPlot2"
    "niworkflows.interfaces.cifti._prepare_cifti"
    "niworkflows.utils.misc.get_template_specs"
    "test_GenerateCifti"
    "test_SimpleShowMaskRPT"
    "test_cifti_surfaces_plot"
  ];

  disabledTestPaths = [
    "niworkflows/tests/test_registration.py"
  ];

  pythonImportsCheck = [ "niworkflows" ];

  meta = {
    description = "Common workflows for MRI (anatomical, functional, diffusion, etc.)";
    mainProgram = "niworkflows-boldref";
    homepage = "https://github.com/nipreps/niworkflows";
    changelog = "https://github.com/nipreps/niworkflows/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
