{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, hypothesis
, pandas
, numpy
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "1.6.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-dJz6OzzjqWZwzDVJzJVUshK0HDP/Bz5cML0TrwVVcvg=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
    pandas
  ];

  disabledTests = [
    "test_levenshtein_block" # hypothesis data generation too slow
  ];

  pythonImportsCheck = [
    "rapidfuzz.fuzz"
    "rapidfuzz.string_metric"
    "rapidfuzz.process"
    "rapidfuzz.utils"
  ];

  meta = with lib; {
    description = "Rapid fuzzy string matching";
    homepage = "https://github.com/maxbachmann/rapidfuzz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
