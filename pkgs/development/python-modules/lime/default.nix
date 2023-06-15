{ lib
, fetchPypi
, buildPythonPackage

, matplotlib, numpy, scipy, tqdm, scikit-learn-extra, scikit-image

, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lime";
  version = "0.2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dpYOTwVf61Pom1AiODuvyHtj8lusYmWYSwozPRpX94E=";
  };

  propagatedBuildInputs =  [
    matplotlib
    numpy
    scipy
    tqdm
    scikit-learn-extra
    scikit-image
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # touches network
    "lime/tests/test_lime_text.py"
  ];

  meta = with lib; {
    description = "Local Interpretable Model-Agnostic Explanations for machine learning classifiers";
    homepage = "https://github.com/marcotcr/lime";
    changelog = "https://github.com/marcotcr/lime/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with lib.maintainers; [ khaser ];
  };
}
