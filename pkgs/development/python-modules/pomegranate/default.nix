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
  version = "1.0.3";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    rev = "f8ed453337fae6b44eddcbfe0d1031d33d8bea76";
    hash = "sha256-OdXLP/GpBqY28q3tcIfJRQ+nI82BfBwjLfCm1hIjw8U=";
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

  # These tests seem to be broken as of 1.0.1
  disabledTests = [
    "sample"
    "test_categorical_exact"
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
