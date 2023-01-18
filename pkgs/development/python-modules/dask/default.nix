{ lib
, stdenv
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
  version = "2023.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-avyrKBAPyYZBNgItnkNCferqb6+4yeGpBAZhSkL/fFA=";
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

  checkInputs = [
    fastparquet
    pyarrow
    pytestCheckHook
    pytest-rerunfailures
    pytest-xdist
    scipy
    zarr
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
    # DeprecationWarning: The 'sym_pos' keyword is deprecated and should be replaced by using 'assume_a = "pos"'. 'sym_pos' will be removed in SciPy 1.11.0.
    "-W" "ignore::DeprecationWarning"
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
