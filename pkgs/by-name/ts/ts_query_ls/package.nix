{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ts_query_ls";
  version = "3.15.1";

  src = fetchFromGitHub {
    owner = "ribru17";
    repo = "ts_query_ls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m3jtaVYy/mNhM584asctI9ZUdaHvPr3ULRHYmmyKsLA=";
  };

  nativeBuildInputs = [ cmake ];

  cargoHash = "sha256-XHMVga5tdWv+yT0vhFd6RQ2N740Zkb3e76wqIc1hbnE=";

  meta = {
    description = "LSP implementation for Tree-sitter's query files";
    homepage = "https://github.com/ribru17/ts_query_ls";
    changelog = "https://github.com/ribru17/ts_query_ls/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ribru17 ];
    mainProgram = "ts_query_ls";
  };
})
