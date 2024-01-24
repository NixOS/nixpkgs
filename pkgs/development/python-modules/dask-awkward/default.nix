{ lib
, awkward
, buildPythonPackage
, dask
, fetchFromGitHub
, hatch-vcs
, hatchling
, pyarrow
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "dask-awkward";
  version = "2024.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = "dask-awkward";
    rev = "refs/tags/${version}";
    hash = "sha256-5UyB/qFfQPLA1N3L6NipW6+FzI0x6hZXu6ickAktlYw=";
  };

  pythonRelaxDeps = [
    "awkward"
  ];

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    awkward
    dask
  ];

  checkInputs = [
    pytestCheckHook
    pyarrow
  ];

  pythonImportsCheck = [
    "dask_awkward"
  ];

  disabledTests = [
    # Tests require network access
    "test_remote_double"
    "test_remote_single"
    "test_from_text"
  ];

  meta = with lib; {
    description = "Native Dask collection for awkward arrays, and the library to use it";
    homepage = "https://github.com/dask-contrib/dask-awkward";
    changelog = "https://github.com/dask-contrib/dask-awkward/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
