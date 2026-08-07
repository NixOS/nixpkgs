{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  antlr4-python3-runtime,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "oci-lexer-parser";
  version = "0.1.2-unstable-2026-08-03";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NetSPI";
    repo = "oci-lexer-parser";
    # https://github.com/NetSPI/oci-lexer-parser/issues/15
    rev = "bc3c90c411009cf12ad44690d4ad2a0b172f9f1b";
    hash = "sha256-AAOPMR94zH57pW5S8NAjzakXR3CyI5kLFXwfvOoOn4c=";
  };

  build-system = [ setuptools ];

  dependencies = [ antlr4-python3-runtime ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oci_lexer_parser" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to convert OCI IAM Policy Statements and Dynamic Group Matching Rules to serialized JSON output";
    homepage = "https://github.com/NetSPI/oci-lexer-parser";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
