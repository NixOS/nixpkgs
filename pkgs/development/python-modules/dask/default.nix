{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

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
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2025.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask";
    tag = version;
    hash = "sha256-bwM4Q95YTEp9pDz6LmBLOeYjmi8nH8Cc/srZlXfEIlg=";
  };

  postPatch = ''
    # versioneer hack to set version of GitHub package
    echo "def get_versions(): return {'dirty': False, 'error': None, 'full-revisionid': None, 'version': '${version}'}" > dask/_version.py

    substituteInPlace setup.py \
      --replace-fail "import versioneer" "" \
      --replace-fail "version=versioneer.get_version()," "version='${version}'," \
      --replace-fail "cmdclass=versioneer.get_cmdclass()," ""

    substituteInPlace pyproject.toml \
      --replace-fail ', "versioneer[toml]==0.29"' ""
  '';

  build-system = [ setuptools ];

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
    pytest-xdist
    pytestCheckHook
    versionCheckHook
  ]
  ++ optional-dependencies.array
  ++ optional-dependencies.dataframe;
  versionCheckProgramArg = "--version";

  pytestFlags = [
    # Rerun failed tests up to three times
    "--reruns=3"
  ];

  disabledTestMarks = [
    # Don't run tests that require network access
    "network"
  ];

  disabledTests = [
    # UserWarning: Insufficient elements for `head`. 10 elements requested, only 5 elements available. Try passing larger `npartitions` to `head`.
    "test_set_index_head_nlargest_string"
  ];

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
