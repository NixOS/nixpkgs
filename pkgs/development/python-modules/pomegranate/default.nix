{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, numpy
, scipy
, torch
, networkx
, apricot-select
, scikit-learn
, pytestCheckHook
, nose
}:


buildPythonPackage rec {
  pname = "pomegranate";
  version = "1.0.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    rev = "v${version}";
    hash = "sha256-EnxKlRRfsOIDLAhYOq7bUSbI/NvPoSyYCZ9D5VCXFGQ=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    torch
    networkx
    scikit-learn
    apricot-select
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  # These tests seem to be broken as of 1.0.0
  disabledTests = [
    "sample"
    "test_learn_structure_chow_liu"
    "test_learn_structure_exact"
    "test_categorical_chow_liu"
    "test_categorical_exact"
    "test_categorical_learn_structure"
  ];

  pythonImportsCheck = [
    "pomegranate"
    "pomegranate.distributions"
    "pomegranate.gmm"
    "pomegranate.bayes_classifier"
    "pomegranate.hmm"
    "pomegranate.markov_chain"
    "pomegranate.bayesian_network"
    "pomegranate.factor_graph"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Fast, flexible and easy to use probabilistic modelling in Python.";
    homepage = "https://github.com/jmschrei/pomegranate";
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
    changelog = "https://github.com/jmschrei/${pname}/releases/tag/v${version}";
  };
}
