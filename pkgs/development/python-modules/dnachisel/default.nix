{
  lib,
  biopython,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  flametree,
  genome-collector,
  matplotlib,
  numpy,
  primer3,
  proglog,
  pytestCheckHook,
  python-codon-tables,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dnachisel";
  version = "3.2.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Edinburgh-Genome-Foundry";
    repo = "DnaChisel";
    tag = "v${version}";
    hash = "sha256-F+G7dwehUCHYKSGsLQR4OZg2NQ4677XMlN6jOcmz8No=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
  ];

  pythonImportsCheck = [ "dnachisel" ];

  meta = with lib; {
    homepage = "https://github.com/Edinburgh-Genome-Foundry/DnaChisel";
    description = "Optimize DNA sequences under constraints";
    changelog = "https://github.com/Edinburgh-Genome-Foundry/DnaChisel/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
