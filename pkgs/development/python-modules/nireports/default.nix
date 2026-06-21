{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  nipreps-versions,
  acres,
  lxml,
  matplotlib,
  nibabel,
  nilearn,
  nipype,
  numpy,
  pandas,
  pybids,
  pyyaml,
  seaborn,
  templateflow,
  texlive,
  texlivePackages,
  ghostscript,
  pytestCheckHook,
  pytest-env,
}:
let
  tex = texlive.combine {
    inherit (texlive)
      scheme-small
      type1cm
      cm-super
      dvipng
      ;
  };
in
buildPythonPackage rec {
  pname = "nireports";
  version = "25.3.0";
  pyproject = true;
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  src = fetchFromGitHub {
    owner = "nipreps";
    repo = "nireports";
    rev = version;
    hash = "sha256-HHAKc0CC7GB6kqXQ0yVvK79SIe1PQjySSt69nPomc3s=";
  };

  build-system = [
    hatch-vcs
    hatchling
    nipreps-versions
  ];

  dependencies = [
    acres
    lxml
    matplotlib
    nibabel
    nilearn
    nipype
    numpy
    pandas
    pybids
    pyyaml
    seaborn
    templateflow
    tex
    ghostscript
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-env
    tex
    ghostscript
  ];

  preCheck = ''
    export MPLCONFIGDIR=$(mktemp -d)
    export TEMPLATEFLOW_HOME=$(mktemp -d)
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # require network access to templateflow S3
    "test_ROIsPlot"
    "test_ROIsPlot2"
    "test_SimpleShowMaskRPT"
    "test_BrainExtractionRPT"
    "test_compression"
    "test_cifti_surfaces_plot"
    "test_mriqc_plot_mosaic"
    "test_mriqc_plot_mosaic_1"
    "test_mriqc_plot_mosaic_2"
    "test_plot_dist"
  ];

  # this is needed otherwise pytest expects pytest-cov
  pytestFlagsArray = [
    "--override-ini=addopts="
  ];

  pythonImportsCheck = [ "nireports" ];

  meta = {
    description = "NiPreps' Reporting and Visualization system - report templates and reportlets";
    homepage = "https://github.com/nipreps/nireports";
    changelog = "https://github.com/nipreps/nireports/blob/${version}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dinga92 ];
  };
}
