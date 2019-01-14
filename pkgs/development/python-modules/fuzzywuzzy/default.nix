{ lib , buildPythonPackage , fetchPypi, pycodestyle }:

buildPythonPackage rec {
  pname = "fuzzywuzzy";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qid283ysgzn3pm6pdm9dy9mghsa511dl5md80fwgq80vd3xwjbg";
  };

  propagatedBuildInputs = [
    pycodestyle
  ];

  meta = with lib; {
    description = "Fuzzy String Matching in Python";
    homepage = https://github.com/seatgeek/fuzzywuzzy;
    license = licenses.gpl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
