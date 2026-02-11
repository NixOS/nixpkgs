{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uwc";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "uwc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qv8vMjCMhpVxkJyH1uTsFXu2waO8oaLPuoBETaWOUqI=";
  };

  cargoHash = "sha256-9inL/z19lbZY8OxIjut3d/HJJXQzZi/cL750Cx98Kcg=";

  doCheck = false;

  meta = {
    description = "Like wc, but unicode-aware, and with per-line mode";
    mainProgram = "uwc";
    homepage = "https://github.com/dead10ck/uwc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
})
