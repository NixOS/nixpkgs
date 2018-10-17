{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gmdcdvh21v33ldg8kbxi7lph7znl2zdz1ic45100z4hx65w1sd9";
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
