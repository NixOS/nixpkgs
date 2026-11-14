{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycryptodome";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GXyZTJsEVHw0geWlEBwPbMvY4T5f1sPIz0rw/eIO2b8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export PYTHONPATH="test_vectors:$PYTHONPATH"
  '';

  pythonImportsCheck = [ "Crypto" ];

  meta = {
    description = "Self-contained cryptographic library";
    homepage = "https://github.com/Legrandin/pycryptodome";
    changelog = "https://github.com/Legrandin/pycryptodome/blob/${finalAttrs.src.tag}/Changelog.rst";
    license = with lib.licenses; [
      bsd2 # and
      asl20
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
