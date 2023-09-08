{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, wheel

# dependencies
, click
, cloudpickle
, fsspec
, importlib-metadata
, packaging
, partd
, pyyaml
, toolz

# optional-dependencies
, numpy
, pyarrow
, lz4
, pandas
, distributed
, bokeh
, jinja2

# tests
, arrow-cpp
, hypothesis
, pytest-asyncio
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2023.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask";
    rev = "refs/tags/${version}";
    hash = "sha256-ZKjfxTJCu3EUOKz16+VP8+cPqQliFNc7AU1FPC1gOXw=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    click
    cloudpickle
    fsspec
    packaging
    partd
    pyyaml
    importlib-metadata
    toolz
  ];

  passthru.optional-dependencies = lib.fix (self: {
    array = [
      numpy
    ];
    complete = [
      pyarrow
      lz4
    ]
    ++ self.array
    ++ self.dataframe
    ++ self.distributed
    ++ self.diagnostics;
    dataframe = [
      numpy
      pandas
    ];
    distributed = [
      distributed
    ];
    diagnostics = [
      bokeh
      jinja2
    ];
  });

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
    pytest-xdist
    # from panda[test]
    hypothesis
    pytest-asyncio
  ] ++ lib.optionals (!arrow-cpp.meta.broken) [ # support is sparse on aarch64
    pyarrow
  ];

  dontUseSetuptoolsCheck = true;

  postPatch = ''
    # versioneer hack to set version of GitHub package
    echo "def get_versions(): return {'dirty': False, 'error': None, 'full-revisionid': None, 'version': '${version}'}" > dask/_version.py

    substituteInPlace setup.py \
      --replace "import versioneer" "" \
      --replace "version=versioneer.get_version()," "version='${version}'," \
      --replace "cmdclass=versioneer.get_cmdclass()," ""

    substituteInPlace pyproject.toml \
      --replace ', "versioneer[toml]==0.28"' "" \
      --replace " --durations=10" "" \
      --replace " --cov-config=pyproject.toml" "" \
      --replace "\"-v" "\" "
  '';

  pytestFlagsArray = [
    # Rerun failed tests up to three times
    "--reruns 3"
    # Don't run tests that require network access
    "-m 'not network'"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Test requires features of python3Packages.psutil that are
    # blocked in sandboxed-builds
    "test_auto_blocksize_csv"
    # AttributeError: 'str' object has no attribute 'decode'
    "test_read_dir_nometa"
  ] ++ [
    # https://github.com/dask/dask/issues/10347#issuecomment-1589683941
    "test_concat_categorical"
    # AttributeError: 'ArrowStringArray' object has no attribute 'tobytes'. Did you mean: 'nbytes'?
    "test_dot"
    "test_dot_nan"
    "test_merge_column_with_nulls"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "dask"
    "dask.array"
    "dask.bag"
    "dask.bytes"
    "dask.dataframe"
    "dask.dataframe.io"
    "dask.dataframe.tseries"
    "dask.diagnostics"
  ];

  meta = with lib; {
    description = "Minimal task scheduling abstraction";
    homepage = "https://dask.org/";
    changelog = "https://docs.dask.org/en/latest/changelog.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
