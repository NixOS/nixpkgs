{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  setuptools,
}:

let
  test-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage (finalAttrs: {
  pname = "pycryptodome";
  version = "4.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JZgNPikN4Wl4ky44zQt66zAVk1udA4B+HwPGbQKRdik=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ test-vectors ];

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
