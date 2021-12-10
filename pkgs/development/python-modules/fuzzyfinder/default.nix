{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fuzzyfinder";
  version = "2.1.0";

  src = fetchFromGitHub {
     owner = "amjith";
     repo = "fuzzyfinder";
     rev = "2.1.0";
     sha256 = "10wmapzb3v5rn93bsa3nsi5ajk84s9msy39lsr43arw2v07fralv";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fuzzyfinder" ];

  meta = with lib; {
    description = "Fuzzy Finder implemented in Python";
    homepage = "https://github.com/amjith/fuzzyfinder";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
