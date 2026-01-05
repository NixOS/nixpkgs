{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitLab,
  setuptools,
  dill,
  h5py,
  nibabel,
  numpy,
  scipy,
  indexed-gzip,
  pillow,
  rtree,
  trimesh,
  wxpython,
  pytestCheckHook,
  pytest-cov-stub,
  tomli,
}:

buildPythonPackage rec {
  pname = "fslpy";
  version = "3.23.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "fslpy";
    rev = "refs/tags/${version}";
    hash = "sha256-lY/7TNOqGK0pRm5Rne1nrqXVQDZPkHwlZV9ITsOwp9Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dill
    h5py
    nibabel
    numpy
    scipy
  ];

  optional-dependencies = {
    extra = [
      indexed-gzip
      pillow
      rtree
      trimesh
      wxpython
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    tomli
  ]
  ++ optional-dependencies.extra;

  disabledTestPaths = [
    # tries to download data:
    "fsl/tests/test_dicom.py"
    # tests exit with "SystemExit: Unable to access the X Display, is $DISPLAY set properly?"
    "fsl/tests/test_idle.py"
    "fsl/tests/test_platform.py"
    # require FSL's atlas library (via $FSLDIR), which has an unfree license:
    "fsl/tests/test_atlases.py"
    "fsl/tests/test_atlases_query.py"
    "fsl/tests/test_parse_data.py"
    "fsl/tests/test_scripts/test_atlasq_list_summary.py"
    "fsl/tests/test_scripts/test_atlasq_ohi.py"
    "fsl/tests/test_scripts/test_atlasq_query.py"
    # requires FSL (unfree and not in Nixpkgs):
    "fsl/tests/test_fslsub.py"
    "fsl/tests/test_run.py"
    "fsl/tests/test_wrappers"
  ];

  pythonImportsCheck = [
    "fsl"
    "fsl.data"
    "fsl.scripts"
    "fsl.transform"
    "fsl.utils"
    "fsl.wrappers"
  ];

  meta = {
    description = "FSL Python library";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/fslpy";
    changelog = "https://git.fmrib.ox.ac.uk/fsl/fslpy/-/blob/main/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
