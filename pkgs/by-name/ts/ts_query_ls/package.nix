{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ts_query_ls";
  version = "3.16.0";

  src = fetchFromGitHub {
    owner = "ribru17";
    repo = "ts_query_ls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cp+fPYkALMpkKsRscpwmW49j3URMoQ/5IbYnN2DaFF0=";
  };

  nativeBuildInputs = [ cmake ];

  cargoHash = "sha256-NSaqxLVl3zsSMSRss//gwI3gvRt1xT9LD7m4BmfKz4U=";

  meta = {
    description = "LSP implementation for Tree-sitter's query files";
    homepage = "https://github.com/ribru17/ts_query_ls";
    changelog = "https://github.com/ribru17/ts_query_ls/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ribru17 ];
    mainProgram = "ts_query_ls";
  };
})
