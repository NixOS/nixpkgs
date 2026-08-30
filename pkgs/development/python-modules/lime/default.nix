{
  lib,
  fetchPypi,
  buildPythonPackage,

  setuptools,

  matplotlib,
  numpy,
  scipy,
  tqdm,
  scikit-learn,
  scikit-image,

  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lime";
  version = "0.2.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-dpYOTwVf61Pom1AiODuvyHtj8lusYmWYSwozPRpX94E=";
  };

  postPatch = ''
    substituteInPlace lime/tests/test_scikit_image.py \
      --replace-fail "random_seed" "rng"
  '';

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    numpy
    scipy
    tqdm
    scikit-learn
    scikit-image
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # touches network
    "lime/tests/test_lime_text.py"
    # slightly flaky
    "lime/tests/test_lime_tabular.py::TestLimeTabular::test_lime_explainer_entropy_discretizer"
  ];

  pythonImportsCheck = [
    "lime.exceptions"
    "lime.explanation"
    "lime.lime_base"
    "lime.lime_image"
    "lime.lime_text"
  ];

  meta = {
    description = "Local Interpretable Model-Agnostic Explanations for machine learning classifiers";
    homepage = "https://github.com/marcotcr/lime";
    changelog = "https://github.com/marcotcr/lime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ khaser ];
  };
})
