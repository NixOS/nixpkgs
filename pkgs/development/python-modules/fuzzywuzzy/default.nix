{ lib, buildPythonPackage, fetchFromGitHub, python-Levenshtein, pycodestyle, hypothesis, pytest }:

buildPythonPackage rec {
  pname = "fuzzywuzzy";
  version = "0.18.0";

  src = fetchFromGitHub {
     owner = "seatgeek";
     repo = "fuzzywuzzy";
     rev = "0.18.0";
     sha256 = "0zh8xd9k95waipsdz516rn51ya9xxlxbd7ivbka4gnkqm9ah79mc";
  };

  propagatedBuildInputs = [ python-Levenshtein ];
  checkInputs = [ pycodestyle hypothesis pytest ];

  meta = with lib; {
    description = "Fuzzy string matching for Python";
    homepage = "https://github.com/seatgeek/fuzzywuzzy";
    license = licenses.gpl2;
    maintainers = with maintainers; [ earvstedt ];
  };
}
