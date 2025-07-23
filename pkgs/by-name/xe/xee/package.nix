{
  lib,
  rustPlatform,
  fetchFromGitHub,
  writers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xee";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Paligo";
    repo = "xee";
    tag = "xee-v${finalAttrs.version}";
    hash = "sha256-l5g2YZ4lNu+CLyya0FavDEqbJayaTXGrB8fYCr3fj0s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ora6VwYLDyFI4iA4FkygGsup8I4OvK0kkLvHs4F/YhY=";

  cargoBuildFlags = [
    "--package"
    "xee"
  ];

  nativeBuildInputs = [
    # "${cargoDeps}/build-data-0.2.1/src/lib.rs" is pretty terrible
    (writers.writePython3Bin "git" { } ''
      import sys
      import os
      sys.argv[0] = os.path.basename(sys.argv[0])
      if sys.argv == ["git", "rev-parse", "HEAD"]:
          print("${finalAttrs.src.rev}")
      elif sys.argv == ["git", "rev-parse", "--abbrev-ref=loose", "HEAD"]:
          print("${finalAttrs.src.rev}")
      elif sys.argv == ["git", "status", "-s"]:
          pass
      elif sys.argv == ["git", "log", "-1", "--pretty=%ct"]:
          print(os.environ.get("SOURCE_DATE_EPOCH", "0"))
      else:
          raise RuntimeError(sys.argv[1:])
    '')
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "XML Execution Engine written in Rust";
    longDescription = ''
      Load XML documents, issue XPath expressions against them, including in
      a REPL, and pretty-print XML documents. A Swiss Army knife CLI for XML.
    '';
    homepage = "https://github.com/Paligo/xee";
    changelog = "https://github.com/Paligo/xee/releases/tag/xee-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "xee";
  };
})
