{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  levenshtein,
  pycodestyle,
}:

buildPythonPackage (finalAttrs: {
  pname = "fuzzywuzzy";
  version = "0.18.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "fuzzywuzzy";
    hash = "sha256-RQFukiZHgOWJctyhs9k5rIZLeEN0Ir7s67MJX479AOg=";
  };

  build-system = [ setuptools ];

  dependencies = [ levenshtein ];

  nativeCheckInputs = [
    pytestCheckHook
    pycodestyle
  ];

  pythonImportsCheck = [
    "fuzzywuzzy"
  ];

  meta = {
    description = "Fuzzy string matching for Python";
    homepage = "https://github.com/seatgeek/fuzzywuzzy";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
})
