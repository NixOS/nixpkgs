{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  pythonAtLeast,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  click,
  cloudpickle,
  fsspec,
  importlib-metadata,
  packaging,
  partd,
  pyyaml,
  toolz,

  # optional-dependencies
  numpy,
  pyarrow,
  lz4,
  pandas,
  distributed,
  bokeh,
  jinja2,

  # tests
  hypothesis,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-rerunfailures,
<<<<<<< HEAD
  pytest-timeout,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "dask";
<<<<<<< HEAD
  version = "2025.12.0";
=======
  version = "2025.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-oGBOt2ULLn0Kx1rOVNWaC3l1ECotMC2yNeCHya9Tx+s=";
  };

  # https://github.com/dask/dask/issues/12043
  postPatch = lib.optionalString (pythonAtLeast "3.14") ''
    substituteInPlace dask/dataframe/dask_expr/tests/_util.py \
      --replace-fail "except AttributeError:" "except (AttributeError, pickle.PicklingError):"
  '';

=======
    hash = "sha256-cU4w4dqJQ3ew+fRyD7Lc4URNfW738kKqls6k6j65pIo=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    cloudpickle
    fsspec
    importlib-metadata
    packaging
    partd
    pyyaml
    toolz
  ];

  optional-dependencies = lib.fix (self: {
    array = [ numpy ];
    complete = [
      pyarrow
      lz4
    ]
    ++ self.array
    ++ self.dataframe
    ++ self.distributed
    ++ self.diagnostics;
    dataframe = [
      pandas
      pyarrow
    ]
    ++ self.array;
    distributed = [ distributed ];
    diagnostics = [
      bokeh
      jinja2
    ];
  });

  nativeCheckInputs = [
    hypothesis
    pyarrow
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytest-rerunfailures
<<<<<<< HEAD
    pytest-timeout
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pytest-xdist
    pytestCheckHook
    versionCheckHook
  ]
  ++ optional-dependencies.array
  ++ optional-dependencies.dataframe;
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pytestFlags = [
    # Rerun failed tests up to three times
    "--reruns=3"
  ];

  disabledTestMarks = [
    # Don't run tests that require network access
    "network"
  ];

<<<<<<< HEAD
  # https://github.com/dask/dask/issues/12042
  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    "test_multiple_repartition_partition_size"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "dask"
    "dask.bag"
    "dask.bytes"
    "dask.diagnostics"

    # Requires the `dask.optional-dependencies.array` that are only in `nativeCheckInputs`
    "dask.array"
    # Requires the `dask.optional-dependencies.dataframe` that are only in `nativeCheckInputs`
    "dask.dataframe"
    "dask.dataframe.io"
    "dask.dataframe.tseries"
  ];

  meta = {
    description = "Minimal task scheduling abstraction";
    mainProgram = "dask";
    homepage = "https://dask.org/";
    changelog = "https://docs.dask.org/en/latest/changelog.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
