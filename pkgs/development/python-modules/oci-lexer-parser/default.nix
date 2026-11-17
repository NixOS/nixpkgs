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
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NetSPI";
    repo = "oci-lexer-parser";
    tag = finalAttrs.version;
    hash = "sha256-h1eZgw2k5QOsU6KyYIDuuWu+wRRcZc30u0mJ2g3TL1w=";
  };

  build-system = [ setuptools ];

  dependencies = [ antlr4-python3-runtime ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oci_lexer_parser" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to convert OCI IAM Policy Statements and Dynamic Group Matching Rules to serialized JSON output";
    homepage = "https://github.com/NetSPI/oci-lexer-parser";
    changelog = "https://github.com/NetSPI/oci-lexer-parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
