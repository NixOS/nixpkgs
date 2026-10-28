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
  numpy,

  # optional-dependencies
  # accel
  numba,
  # dask
  dask,
  # doc
  furo,
  pytest,
  sphinx,
  # full
  h5py,
  zarr,
  # test
  anndata,
  scikit-learn,
  # test-min
  coverage,
  pytest-codspeed,
  pytest-doctestplus,
  pytest-xdist,
  # testing
  packaging,

  # tests
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "fast-array-utils";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "fast-array-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9tB8cV3i9WPbdLeS5/FmQzLu8rk/jRVtUZ35X/XSCx8=";
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
    numpy
  ];

  optional-dependencies = lib.fix (self: {
    accel = [
      numba
    ];
    dask = [
      dask
    ];
    doc = [
      furo
      pytest
      sphinx
      # sphinx-autofixture
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
    test = [
      anndata
      scikit-learn
      zarr
    ]
    ++ self.accel;
    test-min = [
      coverage
      pytest
      pytest-codspeed
      pytest-doctestplus
      pytest-xdist
    ]
    ++ self.sparse
    ++ self.testing;
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
