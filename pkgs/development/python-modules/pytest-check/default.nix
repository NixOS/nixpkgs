{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "2.3.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    hash = "sha256-UbjxiozKpCbF2RPE4ORvAUqqdXlIHqA9Itfh9Jj2ibI=";
  };

  nativeBuildInputs = [ flit-core ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_check" ];

  meta = with lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    changelog = "https://github.com/okken/pytest-check/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
