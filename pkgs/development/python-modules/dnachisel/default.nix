{ lib
, buildPythonPackage
, fetchFromGitHub
, biopython
, docopt
, flametree
, numpy
, proglog
, pytestCheckHook
, python-codon-tables
, primer3
, genome-collector
, matplotlib
}:

buildPythonPackage rec {
  pname = "dnachisel";
  version = "3.2.9";

  src = fetchFromGitHub {
    owner = "Edinburgh-Genome-Foundry";
    repo = "DnaChisel";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Fg0gkI+01xIt8LQmNmRzkzd4AObg/99x34y5NclMtDQ=";
  };

  propagatedBuildInputs = [
    biopython
    docopt
    flametree
    numpy
    proglog
    python-codon-tables
  ];

  checkInputs = [
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
   ];
  pythonImportsCheck = [ "dnachisel" ];

  meta = with lib; {
    homepage = "https://github.com/Edinburgh-Genome-Foundry/DnaChisel";
    description = "Optimize DNA sequences under constraints";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
