{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "uwc";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "uwc";
    tag = "v${version}";
    hash = "sha256-Qv8vMjCMhpVxkJyH1uTsFXu2waO8oaLPuoBETaWOUqI=";
  };

  cargoHash = "sha256-9inL/z19lbZY8OxIjut3d/HJJXQzZi/cL750Cx98Kcg=";

  doCheck = false;

  meta = with lib; {
    description = "Like wc, but unicode-aware, and with per-line mode";
    mainProgram = "uwc";
    homepage = "https://github.com/dead10ck/uwc";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
