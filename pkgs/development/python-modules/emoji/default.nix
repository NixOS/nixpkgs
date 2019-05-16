{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ae01495fc3fcc04e9136ca1af8cae58726ec5dfaaa92f61f0732cbae9a12fa9";
  };

  checkInputs = [ nose ];

  checkPhase = ''nosetests'';

  meta = with lib; {
    description = "Emoji for Python";
    homepage = https://pypi.python.org/pypi/emoji/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
