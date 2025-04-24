{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  packaging,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "14.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SkALy808ekrRUauK+sEj2Q7KOr4n+Ycl3E2XAoh9LpI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/pytest-dev/pytest-rerunfailures/issues/267
    "test_run_session_teardown_once_after_reruns"
    "test_exception_matches_rerun_except_query"
    "test_exception_not_match_rerun_except_query"
    "test_exception_matches_only_rerun_query"
    "test_exception_match_only_rerun_in_dual_query"
  ];

  meta = with lib; {
    description = "Pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ das-g ];
  };
}
