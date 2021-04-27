{ lib
, bokeh
, buildPythonPackage
, fetchpatch
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
  version = "2021.03.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "LACv7lWpQULQknNGX/9vH9ckLsypbqKDGnsNBgKT1eI=";
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

  patches = [
    # dask dataframe cannot be imported in sandboxed builds
    # See https://github.com/dask/dask/pull/7601
    (fetchpatch {
      url = "https://github.com/dask/dask/commit/9ce5b0d258cecb3ef38fd844135ad1f7ac3cea5f.patch";
      sha256 = "sha256-1EVRYwAdTSEEH9jp+UOnrijzezZN3iYR6q6ieYJM3kY=";
      name = "fix-dask-dataframe-imports-in-sandbox.patch";
    })
  ];

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

  disabledTests = [
    "test_annotation_pack_unpack"
    "test_annotations_blockwise_unpack"
    # this test requires features of python3Packages.psutil that are
    # blocked in sandboxed-builds
    "test_auto_blocksize_csv"
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
