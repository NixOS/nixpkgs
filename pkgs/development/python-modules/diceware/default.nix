{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  fetchpatch2,
}:

buildPythonPackage rec {
  pname = "diceware";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VLaQgJ8MVqswhaGOFaDDgE1KDRJ/OK7wtc9fhZ0PZjk=";
  };

  patches = [
    (fetchpatch2 {
      # Set prog in ArgumentParser explicitly to fix test failure with Python 3.14
      # https://github.com/ulif/diceware/issues/122
      url = "https://github.com/ulif/diceware/commit/77d98606748df7755f36ebbb3bd838b1cdd80c61.patch";
      includes = [ "diceware/__init__.py" ];
      hunks = [
        2
        3
      ];
      hash = "sha256-yXGotV/tq7/vCYhY+1OZgCW3r6/SXTTvsHIU/jywbHc=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestMarks = [
    # see https://github.com/ulif/diceware/commit/a7d844df76cd4b95a717f21ef5aa6167477b6733
    "packaging"
  ];

  pythonImportsCheck = [ "diceware" ];

  meta = {
    description = "Generates passphrases by concatenating words randomly picked from wordlists";
    mainProgram = "diceware";
    homepage = "https://github.com/ulif/diceware";
    changelog = "https://github.com/ulif/diceware/blob/v${version}/CHANGES.rst";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ asymmetric ];
  };
}
