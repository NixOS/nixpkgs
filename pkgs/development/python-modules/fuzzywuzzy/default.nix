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
    sha256 = "1s00zn75y2dkxgnbw8kl8dw4p1mc77cv78fwfa4yb0274s96w0a5";
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
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
})
