{ lib
, stdenv
, bokeh
, buildPythonPackage
, cloudpickle
, distributed
, fetchFromGitHub
, fsspec
, jinja2
, numpy
, packaging
, pandas
, partd
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pyyaml
, toolz
, withExtraComplete ? false
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2021.08.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "sha256-HnrHOp3Y/iLYaK3KVp6NJrK68BMqX8lTl/wLosiGc7k=";
  };

  propagatedBuildInputs = [
    cloudpickle
    fsspec
    packaging
    partd
    pyyaml
    toolz
    pandas
    jinja2
    bokeh
    numpy
  ] ++ lib.optionals (withExtraComplete) [
    # infinite recursion between distributed and dask
    distributed
  ];

  doCheck = true;

  checkInputs = [
    pytestCheckHook
    pytest-rerunfailures
    pytest-xdist
  ];

  dontUseSetuptoolsCheck = true;

  postPatch = ''
    # versioneer hack to set version of github package
    echo "def get_versions(): return {'dirty': False, 'error': None, 'full-revisionid': None, 'version': '${version}'}" > dask/_version.py

    substituteInPlace setup.py \
      --replace "version=versioneer.get_version()," "version='${version}'," \
      --replace "cmdclass=versioneer.get_cmdclass()," ""
  '';

  pytestFlagsArray = [
    # parallelize
    "--numprocesses auto"
    # rerun failed tests up to three times
    "--reruns 3"
    # don't run tests that require network access
    "-m 'not network'"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # this test requires features of python3Packages.psutil that are
    # blocked in sandboxed-builds
    "test_auto_blocksize_csv"
  ] ++ [
    # A deprecation warning from newer sqlalchemy versions makes these tests
    # to fail https://github.com/dask/dask/issues/7406
    "test_sql"
    # Test interrupt fails intermittently https://github.com/dask/dask/issues/2192
    "test_interrupt"
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
