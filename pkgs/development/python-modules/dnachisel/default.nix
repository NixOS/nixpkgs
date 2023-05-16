{ lib
, buildPythonPackage
, fetchFromGitHub
, biopython
, docopt
, flametree
, numpy
, proglog
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python-codon-tables
, primer3
, genome-collector
, matplotlib
}:

buildPythonPackage rec {
  pname = "dnachisel";
<<<<<<< HEAD
  version = "3.2.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "3.2.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Edinburgh-Genome-Foundry";
    repo = "DnaChisel";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-rcZq/HhU1xIyQ1jM8+gO9ONDLBAxiUIByoWk2nMwuGA=";
=======
    hash = "sha256-YlNOvK7ZXUHYdRX1NFEdZ646NGLtGXU1YgAjN6RY2QE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    biopython
    docopt
    flametree
    numpy
    proglog
    python-codon-tables
  ];

  nativeCheckInputs = [
    primer3
    genome-collector
    matplotlib
    pytestCheckHook
  ];

  # Disable tests which requires network access
  disabledTests = [
    "test_circular_sequence_optimize_with_report"
    "test_constraints_reports"
    "test_optimize_with_report"
    "test_optimize_with_report_no_solution"
    "test_avoid_blast_matches_with_list"
    "test_avoid_phage_blast_matches"
    "test_avoid_matches_with_list"
    "test_avoid_matches_with_phage"
<<<<<<< HEAD
  ];

  pythonImportsCheck = [
    "dnachisel"
  ];
=======
   ];
  pythonImportsCheck = [ "dnachisel" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/Edinburgh-Genome-Foundry/DnaChisel";
    description = "Optimize DNA sequences under constraints";
<<<<<<< HEAD
    changelog = "https://github.com/Edinburgh-Genome-Foundry/DnaChisel/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
