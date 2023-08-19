{ lib
, stdenv
, apricot-select
, buildPythonPackage
, fetchFromGitHub
, networkx
, nose
, numpy
, pytestCheckHook
, pythonOlder
, scikit-learn
, scipy
, torch
}:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmschrei";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EnxKlRRfsOIDLAhYOq7bUSbI/NvPoSyYCZ9D5VCXFGQ=";
  };

  propagatedBuildInputs = [
    apricot-select
    networkx
    numpy
    scikit-learn
    scipy
    torch
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  disabledTests = [
    # ValueError and AssertionError
    "test_categorical_chow"
    "test_categorical_exact"
    "test_categorical_learn"
    "test_learn_structure"
    "test_sample"
  ];

  pythonImportsCheck = [
    "pomegranate"
  ];

  meta = with lib; {
    description = "Probabilistic and graphical models for Python";
    homepage = "https://github.com/jmschrei/pomegranate";
    changelog = "https://github.com/jmschrei/pomegranate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
    broken = stdenv.isDarwin;
  };
}
