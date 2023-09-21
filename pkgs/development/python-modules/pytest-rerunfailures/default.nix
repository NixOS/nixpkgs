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
  version = "12.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eE9GL6h/6b33gdACfYVrR6S/5sEq8Qj2vYhwV6kXtI4=";
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
