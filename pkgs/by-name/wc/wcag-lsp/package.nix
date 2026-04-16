{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wcag-lsp";
  version = "0.5.12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maxischmaxi";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-mckcOY4gtfx4sHVTDBTe9aCgtkxQYPIQdwzihAH/Irw=";
  };

  cargoHash = "sha256-gNTBUUHdJVvbmbBR1M/Gnfxb/2PkNm8AvqF/inzh93c=";

  meta = {
    description = "A fast Language Server Protocol (LSP) implementation that checks HTML and JSX/TSX code for WCAG 2.1 accessibility violations in real-time.";
    mainProgram = "wcag-lsp";
    homepage = "https://github.com/maxischmaxi/wcag-lsp";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
