{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, packaging
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "11.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VWEWYehz8cr6OEyC8I0HiDlU9LdkNfS4pbRwwZVFc94=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ das-g ];
  };
}
