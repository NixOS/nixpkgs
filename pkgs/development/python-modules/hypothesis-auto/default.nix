{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  poetry-core,
  pydantic,
  pytest,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hypothesis-auto";
  version = "1.1.5";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "hypothesis_auto";
    inherit version;
    hash = "sha256-U0vcOB9jXmUV5v2IwybVu2arY1FpPnKkP7m2kbD1kRw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pydantic
    hypothesis
    pytest
  ];

  pythonImportsCheck = [ "hypothesis_auto" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Enables fully automatic tests for type annotated functions";
    homepage = "https://github.com/timothycrosley/hypothesis-auto/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
