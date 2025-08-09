{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "diceware";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VLaQgJ8MVqswhaGOFaDDgE1KDRJ/OK7wtc9fhZ0PZjk=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestMarks = [
    # see https://github.com/ulif/diceware/commit/a7d844df76cd4b95a717f21ef5aa6167477b6733
    "packaging"
  ];

  pythonImportsCheck = [ "diceware" ];

  meta = with lib; {
    description = "Generates passphrases by concatenating words randomly picked from wordlists";
    mainProgram = "diceware";
    homepage = "https://github.com/ulif/diceware";
    changelog = "https://github.com/ulif/diceware/blob/v${version}/CHANGES.rst";
    license = licenses.gpl3;
    maintainers = with maintainers; [ asymmetric ];
  };
}
