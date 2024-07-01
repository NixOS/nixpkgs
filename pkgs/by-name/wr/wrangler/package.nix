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
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "${pname}@${version}";
    hash = "sha256-Dd1ngrnQnU2QCSvbsZq51DObjgd3Fq1LkCAqe/Qsd9k=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Dd1ngrnQnU2QCSvbsZq51DObjgd3Fq1LkCAqe/Qsd9k=";
    sourceRoot = "${finalAttrs.src.name}/packages/wrangler";
  };

  pnpmRoot = "packages/wrangler";

  meta = {
    description = "Command-line interface for all things Cloudflare Workers";
    homepage = "https://github.com/cloudflare/workers-sdk#readme";
    license = "MIT OR Apache-2.0";
    maintainers = with lib.maintainers; [ dezren39 ];
    mainProgram = "wrangler";
  };
})
