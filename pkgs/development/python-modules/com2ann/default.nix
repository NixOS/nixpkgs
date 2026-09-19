{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "com2ann";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ilevkivskyi";
    repo = "com2ann";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f84IXuA6d9TPBWUyxxr4NYjf7a5MUKbY59ne3K2Yx1s=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "com2ann" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for translation type comments to type annotations in Python";
    homepage = "https://github.com/ilevkivskyi/com2ann";
    license = lib.licenses.mit;
    mainProgram = "com2ann";
    maintainers = with lib.maintainers; [ winter ];
  };
})
