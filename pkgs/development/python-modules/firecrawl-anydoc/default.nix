{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "firecrawl-anydoc";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firecrawl";
    repo = "anydoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rGv3Bh+zmF9xFUgf8RaSmfyB/gfuQ13iC389i6VZIlM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  # The workspace root is outside of `sourceRoot`, hence not writable
  env.CARGO_TARGET_DIR = "./target";

  cargoRoot = "..";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      sourceRoot
      ;
    hash = "sha256-yhW5HSzVrZCms4x36J2NGIn1e5YLIgjuNKXM9EJ9J8c=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -r anydoc/
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Convert documents (doc, docx, odt, rtf, epub, pdf, presentations, spreadsheets, csv) to GitHub-Flavored Markdown";
    changelog = "https://github.com/firecrawl/anydoc/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/firecrawl/anydoc";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
})
