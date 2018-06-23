{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "001b92b9c8a157e1ca49187745fa450513bc8b31c87328dfd83d674b9d7dfa63";
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
