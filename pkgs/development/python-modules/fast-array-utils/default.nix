{
  buildPythonPackage,
  dask,
  fetchFromGitHub,
  hatch-docstring-description,
  hatch-fancy-pypi-readme,
  hatch-min-requirements,
  hatch-vcs,
  hatchling,
  lib,
  numba,
  numpy,
  pytest-codspeed,
  pytest-doctestplus,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "fast-array-utils";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "fast-array-utils";
    tag = "v${version}";
    hash = "sha256-FUzCdDFDqP+izlSWruWzslfPayzRN7MFx1LOikyMDss=";
  };

  # hatch-min-requirements tries to talk to PyPI by default. See https://github.com/tlambert03/hatch-min-requirements?tab=readme-ov-file#environment-variables.
  env.MIN_REQS_OFFLINE = "1";

  build-system = [
    hatch-docstring-description
    hatch-fancy-pypi-readme
    hatch-min-requirements
    hatch-vcs
    hatchling
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    dask
    numba
    pytest-codspeed
    pytest-doctestplus
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [
    "fast_array_utils.conv"
    "fast_array_utils.types"
    "fast_array_utils.typing"
    "fast_array_utils"
  ];

  meta = {
    description = "Fast array utilities";
    homepage = "https://icb-fast-array-utils.readthedocs-hosted.com";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      samuela
    ];
  };
}
