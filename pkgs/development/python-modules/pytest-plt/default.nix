{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-plt";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IkTNlierFXIG9WSVUfVoirfQ6z7JOYlCaa5NhnBSuxc=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
  ];

  meta = with lib; {
    description = "provides fixtures for quickly creating Matplotlib plots in your tests";
    homepage = "https://www.nengo.ai/pytest-plt/";
    changelog = "https://github.com/nengo/pytest-plt/blob/master/CHANGES.rst";
    license = licenses.mit;
    maintainers = [ maintainers.doronbehar ];
  };
}
