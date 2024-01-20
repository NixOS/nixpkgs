{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, apricot-select
, networkx
, numpy
, scikit-learn
, scipy
, torch

# tests
, pytestCheckHook
, nose
}:


buildPythonPackage rec {
  pname = "pomegranate";
  version = "1.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    # no tags for recent versions: https://github.com/jmschrei/pomegranate/issues/974
    rev = "f8ed453337fae6b44eddcbfe0d1031d33d8bea76";
    hash = "sha256-OdXLP/GpBqY28q3tcIfJRQ+nI82BfBwjLfCm1hIjw8U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    apricot-select
    networkx
    numpy
    scikit-learn
    scipy
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    nose
  ];

  disabledTests = [
    # AssertionError: Arrays are not equal
    "test_sample"
    "test_from_summaries_null"
  ];

  meta = with lib; {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
