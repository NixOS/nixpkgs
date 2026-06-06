{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "arpeggio";
  version = "2.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "Arpeggio";
    inherit (finalAttrs) version;
    hash = "sha256-noWtNc/GyThnaBfHrpoQAKfHKjTHHbDGhxNsRg0SuF4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arpeggio" ];

  meta = {
    description = "Recursive descent parser with memoization based on PEG grammars (aka Packrat parser)";
    homepage = "https://github.com/textX/Arpeggio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
