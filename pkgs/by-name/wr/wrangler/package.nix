{
  stdenv,
  lib,
  pnpm,
  fetchFromGitHub
}:

stdenv.mkDerivation(finalAttrs: {
  pname = "wrangler";
  version = "3.62.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) pname version;
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "${finalAttrs.pname}@${finalAttrs.version}";
    hash = "sha256-/4iIkvSn85fkRggmIha2kRlW0MEwvzy0ZAmIb8+LpZQ=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/4iIkvSn85fkRggmIha2kRlW0MEwvzy0ZAmIb8+LpZQ=";
    sourceRoot = "${finalAttrs.src.name}/packages/wrangler";
  };

  meta = {
    description = "Command-line interface for all things Cloudflare Workers";
    homepage = "https://github.com/cloudflare/workers-sdk#readme";
    license = "MIT OR Apache-2.0";
    maintainers = with lib.maintainers; [ dezren39 ];
    mainProgram = "wrangler";
  };
})
