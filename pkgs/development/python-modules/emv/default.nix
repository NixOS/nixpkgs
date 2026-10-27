{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  click,
  pyscard,
  pycountry,
  terminaltables,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "emv";
  version = "1.0.14";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "russss";
    repo = "python-emv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MnaeQZ0rA3i0CoUA6HgJQpwk5yo4rm9e+pc5XzRd1eg=";
  };

  pythonRelaxDeps = [
    "click"
    "pyscard"
    "pycountry"
    "terminaltables"
  ];

  pythonRemoveDeps = [
    "enum-compat"
    "argparse"
  ];

  build-system = [ setuptools ];

  dependencies = [
    click
    pyscard
    pycountry
    terminaltables
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "emv" ];

  meta = {
    description = "Implementation of the EMV chip-and-pin smartcard protocol";
    homepage = "https://codeberg.org/russss/python-emv/";
    changelog = "https://codeberg.org/russss/python-emv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "emvtool";
  };
})
