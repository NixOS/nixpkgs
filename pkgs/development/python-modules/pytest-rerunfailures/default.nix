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
  version = "11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zuWeTm8Nc65j+6CZhlMUupuRW3GTSVQREPoBL/tu+xM=";
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
