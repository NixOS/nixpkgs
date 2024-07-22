{ lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatch-vcs,
  hatchling,
  nipreps-versions,
  importlib-resources,
  matplotlib,
  nibabel,
  nilearn,
  nipype,
  numpy,
  pandas,
  pybids,
  pyyaml,
  seaborn,
  svgutils,
  templateflow,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "nireports";
  version = "23.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nipreps";
    repo = "nireports";
    rev = version;
    hash = "sha256-kr6nWsCA4GcPLEYV/IPm0N3VRz+Mho209/iNVd+59Ik=";
  };

  build-system = [
    hatch-vcs
    hatchling
    nipreps-versions
  ];

  dependencies = [
    matplotlib
    nibabel
    nilearn
    nipype
    numpy
    pandas
    pybids
    pyyaml
    seaborn
    svgutils
    templateflow
  ] ++ lib.optionals (pythonOlder "3.12") [
    importlib-resources
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    matplotlib
    pytestCheckHook
    pytest-xdist
  ];

  pytestFlagsArray = [ "nireports" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # try to download data:
    "test_cifti_surfaces_plot"
    "test_mriqc_plot_mosaic"
    # fails when run under pytest-xdist
    "test_reportlets.py"
  ];

  pythonImportsCheck = [
    "nireports"
    "nireports.assembler"
    "nireports.interfaces"
    "nireports.reportlets"
    "nireports.tools"
  ];

  meta = with lib; {
    description = "The NiPreps Reporting and Visualization system - report templates and 'reportlets'";
    homepage = "https://nireports.readthedocs.io";
    changelog = "https://github.com/nipreps/nireports/blob/${src.rev}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
