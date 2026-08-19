{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tarts";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "oiwn";
    repo = "tarts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-l1IJFPRk+JM+JBx7/YFB0IBryzo5ce/ekiJ7Ru2sjKE=";
  };

  cargoHash = "sha256-6ptR3TjKxqyo5kUgnIyLEpLN9Lw8sFcTiZ4jgn68x5Q=";

  meta = {
    description = "Screen saves and visual effects for your terminal";
    homepage = "https://github.com/oiwn/tarts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.da157 ];
    mainProgram = "tarts";
  };
})
