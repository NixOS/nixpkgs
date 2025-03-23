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
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    hash = "sha256-UiTvzvBZv38M2iU/jQ9icEtIGf9IyT9RxnWupqAU9lA=";
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
