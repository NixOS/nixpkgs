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
, pytest_xdist
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2.22.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "08nvxj81cz9x92dh2gbmm4imkr8cfljfi2hxkballv2ygwcbzg8g";
  };

  checkInputs = [
    pytestCheckHook
    pytest_xdist # takes >10mins to run single-threaded
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

  # dask test suite with consistently fail when using high core counts
  preCheck = ''
    NIX_BUILD_CORES=$((NIX_BUILD_CORES > 8 ? 8 : NIX_BUILD_CORES))
  '';

  pytestFlagsArray = [ "-n $NIX_BUILD_CORES" ];

  disabledTests = [
    "test_argwhere_str"
    "test_count_nonzero_str"
    "rolling_methods"  # floating percision error ~0.1*10^8 small
    "num_workers_config" # flaky
  ];

  meta = {
    description = "Minimal task scheduling abstraction";
    homepage = "https://github.com/ContinuumIO/dask/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
