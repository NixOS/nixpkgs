{ lib
, stdenv
, arrow-cpp
, bokeh
, buildPythonPackage
, click
, cloudpickle
, distributed
, fastparquet
, fetchFromGitHub
, fetchpatch
, fsspec
, jinja2
, numpy
, packaging
, pandas
, partd
, pyarrow
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pyyaml
, scipy
, toolz
, zarr
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2023.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-7cuTxJ5SxOEf0v+SvSiaz7x8YYTx/qIS+KktbtubiDU=";
  };

  propagatedBuildInputs = [
    click
    cloudpickle
    fsspec
    packaging
    partd
    pyyaml
    toolz
  ];

  passthru.optional-dependencies = {
    array = [
      numpy
    ];
    complete = [
      distributed
    ];
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
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
    pytest-xdist
    scipy
    zarr
  ] ++ lib.optionals (!arrow-cpp.meta.broken) [ # support is sparse on aarch64
    fastparquet
    pyarrow
  ];

  dontUseSetuptoolsCheck = true;

  postPatch = ''
    # versioneer hack to set version of GitHub package
    echo "def get_versions(): return {'dirty': False, 'error': None, 'full-revisionid': None, 'version': '${version}'}" > dask/_version.py

    substituteInPlace setup.py \
      --replace "version=versioneer.get_version()," "version='${version}'," \
      --replace "cmdclass=versioneer.get_cmdclass()," ""

    substituteInPlace setup.cfg \
      --replace " --durations=10" "" \
      --replace " -v" ""
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
    "test_chunksize_files"
    # TypeError: 'ArrowStringArray' with dtype string does not support reduction 'min'
    "test_set_index_string"
    # numpy 1.24
    # RuntimeWarning: invalid value encountered in cast
    "test_setitem_extended_API_2d_mask"
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
