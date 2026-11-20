{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-docstring-description,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,

  # dependencies
  array-api-compat,
  numpy,

  # optional-dependencies
  # accel
  numba,
  # dask
  dask,
  # full
  h5py,
  zarr,
  # sparse
  scipy,
  # testing
  packaging,

  # tests
  pytest-codspeed,
  pytest-doctestplus,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fast-array-utils";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "fast-array-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qOFq0xzi7ylmSqLhGv1QoDQPQW56qsf8dA2A0wcMK3M=";
  };

  # hatch-min-requirements tries to talk to PyPI by default. See https://github.com/tlambert03/hatch-min-requirements?tab=readme-ov-file#environment-variables.
  env.MIN_REQS_OFFLINE = "1";

  build-system = [
    hatch-docstring-description
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    array-api-compat
    numpy
  ];

  optional-dependencies = lib.fix (self: {
    accel = [
      numba
    ];
    dask = [
      dask
    ];
    full = [
      h5py
      zarr
    ]
    ++ self.accel
    ++ self.dask
    ++ self.sparse;
    sparse = [
      scipy
    ];
    testing = [
      packaging
    ];
  });

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
    changelog = "https://github.com/scverse/fast-array-utils/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      samuela
    ];
  };
})
