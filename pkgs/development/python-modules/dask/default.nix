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
  version = "2.14.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "0kj46pwzvdw8ii1h45y48wxvjid89yp4cfak2h4b8z8xic73fqgj";
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

  disabledTests = [
    "test_argwhere_str"
    "test_count_nonzero_str"
  ];

  meta = {
    description = "Minimal task scheduling abstraction";
    homepage = "https://github.com/ContinuumIO/dask/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
