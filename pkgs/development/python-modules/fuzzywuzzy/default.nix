{
  lib,
  buildPythonPackage,
  fetchPypi,
  levenshtein,
  pycodestyle,
  hypothesis,
  pytest,
}:

buildPythonPackage rec {
  pname = "fuzzywuzzy";
  version = "0.18.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RQFukiZHgOWJctyhs9k5rIZLeEN0Ir7s67MJX479AOg=";
  };

  propagatedBuildInputs = [ levenshtein ];
  nativeCheckInputs = [
    pycodestyle
    hypothesis
    pytest
  ];

  meta = with lib; {
    description = "Fuzzy string matching for Python";
    homepage = "https://github.com/seatgeek/fuzzywuzzy";
    license = licenses.gpl2;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
