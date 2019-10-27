{ stdenv, buildPythonPackage, fetchPypi, python-Levenshtein, pycodestyle, hypothesis, pytest }:

buildPythonPackage rec {
  pname = "fuzzywuzzy";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f49de47db00e1c71d40ad16da42284ac357936fa9b66bea1df63fed07122d62";
  };

  propagatedBuildInputs = [ python-Levenshtein ];
  checkInputs = [ pycodestyle hypothesis pytest ];

  meta = with stdenv.lib; {
    description = "Fuzzy string matching for Python";
    homepage = https://github.com/seatgeek/fuzzywuzzy;
    license = licenses.gpl2;
    maintainers = with maintainers; [ earvstedt ];
  };
}
