{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "arpeggio";
  version = "2.0.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "Arpeggio";
    inherit version;
    hash = "sha256-noWtNc/GyThnaBfHrpoQAKfHKjTHHbDGhxNsRg0SuF4=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arpeggio" ];

<<<<<<< HEAD
  meta = {
    description = "Recursive descent parser with memoization based on PEG grammars (aka Packrat parser)";
    homepage = "https://github.com/textX/Arpeggio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
=======
  meta = with lib; {
    description = "Recursive descent parser with memoization based on PEG grammars (aka Packrat parser)";
    homepage = "https://github.com/textX/Arpeggio";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
