{ lib
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

  doCheck = false;

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

  pytestFlagsArray = [ "-n $NIX_BUILD_CORES" ];

  disabledTests = [
    "test_annotation_pack_unpack"
    "test_annotations_blockwise_unpack"
  ];

  meta = with lib; {
    description = "Minimal task scheduling abstraction";
    homepage = "https://dask.org/";
    changelog = "https://docs.dask.org/en/latest/changelog.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
