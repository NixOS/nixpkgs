{ lib
, bokeh
, buildPythonPackage
, fetchFromGitHub
, fsspec
, pytestCheckHook
, pythonOlder
, cloudpickle
, numpy
, toolz
, dill
, pandas
, partd
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2021.01.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "V2cEOzV/L1zjyQ76zlGyN9CIkq6W8y8Yab4NQi3/Ju4=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  dontUseSetuptoolsCheck = true;

  propagatedBuildInputs = [
    bokeh
    cloudpickle
    dill
    fsspec
    numpy
    pandas
    partd
    toolz
  ];

  postPatch = ''
    # versioneer hack to set version of github package
    echo "def get_versions(): return {'dirty': False, 'error': None, 'full-revisionid': None, 'version': '${version}'}" > dask/_version.py

    substituteInPlace setup.py \
      --replace "version=versioneer.get_version()," "version='${version}'," \
      --replace "cmdclass=versioneer.get_cmdclass()," ""
  '';

  #pytestFlagsArray = [ "-n $NIX_BUILD_CORES" ];

  disabledTests = [
    "test_argwhere_str"
    "test_count_nonzero_str"
    "rolling_methods"  # floating percision error ~0.1*10^8 small
    "num_workers_config" # flaky
    "test_2args_with_array[pandas1-darray1-ldexp]"  # flaky
  ];

  meta = {
    description = "Minimal task scheduling abstraction";
    homepage = "https://dask.org/";
    changelog = "https://docs.dask.org/en/latest/changelog.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
