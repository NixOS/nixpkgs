{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gibberish-detector";
  version = "0.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "domanchi";
    repo = "gibberish-detector";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C9hmltg8yZDKwX1AK1xR6Oex/ZQF6zAon3Knae90IOo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gibberish_detector" ];

  meta = {
    description = "Python module to detect gibberish strings";
    mainProgram = "gibberish-detector";
    homepage = "https://github.com/domanchi/gibberish-detector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
