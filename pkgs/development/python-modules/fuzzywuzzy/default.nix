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
    sha256 = "1s00zn75y2dkxgnbw8kl8dw4p1mc77cv78fwfa4yb0274s96w0a5";
  };

  propagatedBuildInputs = [ levenshtein ];
  nativeCheckInputs = [
    pycodestyle
    hypothesis
    pytest
  ];

<<<<<<< HEAD
  meta = {
    description = "Fuzzy string matching for Python";
    homepage = "https://github.com/seatgeek/fuzzywuzzy";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ erikarvstedt ];
=======
  meta = with lib; {
    description = "Fuzzy string matching for Python";
    homepage = "https://github.com/seatgeek/fuzzywuzzy";
    license = licenses.gpl2;
    maintainers = with maintainers; [ erikarvstedt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
