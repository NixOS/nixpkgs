{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "496f432058567985838c13d67dde84ca081614a8286c0b9cdc7d63dfa89d51a3";
  };

  checkInputs = [ nose ];

  checkPhase = "nosetests";

  meta = with lib; {
    description = "Emoji for Python";
    homepage = "https://pypi.python.org/pypi/emoji/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
