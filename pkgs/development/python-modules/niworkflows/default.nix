{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
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
}:

buildPythonPackage rec {
  pname = "niworkflows";
  version = "1.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipreps";
    repo = "niworkflows";
    rev = "refs/tags/${version}";
    hash = "sha256-29ZxLuKrvgCIOMMCUpi0HHhlNlgqUrUrSCiikwecmKw=";
  };

  pythonRelaxDeps = [ "traits" ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
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

  nativeCheckInputs = [ pytestCheckHook ];
  preCheck = ''export HOME=$(mktemp -d)'';
  pytestFlagsArray = [ "niworkflows" ];
  # try to download data:
  disabledTests = [
    "test_GenerateCifti"
    "ROIsPlot"
    "ROIsPlot2"
    "test_SimpleShowMaskRPT"
    "test_cifti_surfaces_plot"
    "niworkflows.utils.misc.get_template_specs"
    "niworkflows.interfaces.cifti._prepare_cifti"
  ];
  disabledTestPaths = [ "niworkflows/tests/test_registration.py" ];

  pythonImportsCheck = [ "niworkflows" ];

  meta = with lib; {
    description = "Common workflows for MRI (anatomical, functional, diffusion, etc.)";
    mainProgram = "niworkflows-boldref";
    homepage = "https://github.com/nipreps/niworkflows";
    changelog = "https://github.com/nipreps/niworkflows/blob/${src.rev}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
