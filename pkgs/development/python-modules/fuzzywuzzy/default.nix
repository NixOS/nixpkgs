{ lib, buildPythonPackage, fetchPypi, python-Levenshtein, pycodestyle, hypothesis, pytest }:

buildPythonPackage rec {
  pname = "fuzzywuzzy";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s00zn75y2dkxgnbw8kl8dw4p1mc77cv78fwfa4yb0274s96w0a5";
  };

  propagatedBuildInputs = [ python-Levenshtein ];
  checkInputs = [ pycodestyle hypothesis pytest ];

  meta = with lib; {
    description = "Fuzzy string matching for Python";
    homepage = "https://github.com/seatgeek/fuzzywuzzy";
    license = licenses.gpl2;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
