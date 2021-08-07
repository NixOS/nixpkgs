{ lib
, stdenv
, bokeh
, buildPythonPackage
, fetchFromGitHub
, fsspec
, pytestCheckHook
, pytest-rerunfailures
, pythonOlder
, cloudpickle
, numpy
, toolz
, dill
, pandas
, partd
, pytest-xdist
, withExtraComplete ? false
, distributed
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2021.06.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "sha256-qvfjdijzlqaJQrDztRAVr5PudTaVd3WOTBid2ElZQgg=";
  };

  propagatedBuildInputs = [
    bokeh
    cloudpickle
    dill
    fsspec
    numpy
    pandas
    partd
    toolz
  ] ++ lib.optionals withExtraComplete [
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
    "-n $NIX_BUILD_CORES"
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

  pythonImportsCheck = [ "dask.dataframe" "dask" "dask.array" ];

  meta = with lib; {
    description = "Minimal task scheduling abstraction";
    homepage = "https://dask.org/";
    changelog = "https://docs.dask.org/en/latest/changelog.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
