{ lib
, fetchPypi
, buildPythonPackage
, matplotlib
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-plt";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IkTNlierFXIG9WSVUfVoirfQ6z7JOYlCaa5NhnBSuxc=";
  };

  buildInputs = [
    matplotlib
    pytest
  ];

  propagatedBuiltInputs = [
    matplotlib
    pytest
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_plt" ];

  meta = with lib; {
    description = "Fixtures for quickly making Matplotlib plots in tests";
    homepage = "https://www.nengo.ai/pytest-plt";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
