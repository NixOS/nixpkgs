{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, awkward
, dask
, hatch-vcs
, hatchling
, pyarrow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dask-awkward";
  version = "2023.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = pname;
    rev = version;
    hash = "sha256-q0mBd4yelnNL7rMWfilituo9h/xmLLLndSCBdY2egEQ=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    awkward
    dask
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  checkInputs = [
    pytestCheckHook
    pyarrow
  ];

  pythonImportsCheck = [
    "dask_awkward"
  ];

  pytestFlagsArray = [
    # require internet
    "--deselect=tests/test_parquet.py::test_remote_double"
    "--deselect=tests/test_parquet.py::test_remote_single"
  ];

  meta = with lib; {
    description = "Native Dask collection for awkward arrays, and the library to use it";
    homepage = "https://github.com/dask-contrib/dask-awkward";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
