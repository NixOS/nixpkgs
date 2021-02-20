{ lib, buildPythonPackage, fetchPypi, nose, pytestCheckHook }:

buildPythonPackage rec {
  pname = "blinker";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dpq0vb01p36jjwbhhd08ylvrnyvcc82yxx3mwjx6awrycjyw6j7";
  };

  checkInputs = [ nose pytestCheckHook ];
  pythonImportsCheck = [ "blinker" ];

  meta = with lib; {
    homepage = "https://pythonhosted.org/blinker/";
    description = "Fast, simple object-to-object and broadcast signaling";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
