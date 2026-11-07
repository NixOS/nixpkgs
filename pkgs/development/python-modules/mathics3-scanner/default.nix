{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  click,
  pyyaml,
  setuptools,
  chardet,
  ujson,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mathics3-scanner";
  version = "10.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mathics3";
    repo = "mathics-scanner";
    tag = finalAttrs.version;
    hash = "sha256-bZcmpxds8DK/IxnzlqKq0uhtodUyrPQQY0LZpGhbSdU=";
  };

  # Tagged sources carry a development version
  postPatch = ''
    substituteInPlace mathics_scanner/version.py \
      --replace-fail '"${finalAttrs.version}.dev0"' '"${finalAttrs.version}"'
  '';

  build-system = [
    click
    pyyaml
    setuptools
  ];

  dependencies = [
    chardet
    click
    pyyaml
  ];

  optional-dependencies = {
    full = [ ujson ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Requires mathics3, which depends on this package
    "test/test_mathics_precedence.py"
  ];

  pythonImportsCheck = [ "mathics_scanner" ];

  meta = {
    description = "Character Tables and Tokenizer for Mathics3 and the Wolfram Language";
    homepage = "https://github.com/Mathics3/mathics-scanner";
    changelog = "https://github.com/Mathics3/mathics-scanner/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
