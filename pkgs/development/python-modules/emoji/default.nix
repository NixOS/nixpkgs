{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "emoji";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18siknldyqvxvjf0nv18m0a1c26ahkg7vmhkij1qayanb0h46vs9";
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
