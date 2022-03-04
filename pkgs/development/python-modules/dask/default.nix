{ lib
, stdenv
, bokeh
, buildPythonPackage
, cloudpickle
, distributed
, fetchFromGitHub
, fetchpatch
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
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2022.02.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-tDqpIS8j6a16YbJak+P1GkCEZvJyheWV5vkUrkhScRY=";
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
    "--numprocesses $NIX_BUILD_CORES"
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

  passthru.extras-require = {
    complete = [ distributed ];
  };

  meta = with lib; {
    description = "Minimal task scheduling abstraction";
    homepage = "https://dask.org/";
    changelog = "https://docs.dask.org/en/latest/changelog.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
