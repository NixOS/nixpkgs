{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tarts";
  version = "0.1.27";

  src = fetchFromGitHub {
    owner = "oiwn";
    repo = "tarts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-usGipUUUIZUxTzNSiq0Dv/g5oFgRJMmLUzbaIAWojws=";
  };

  cargoHash = "sha256-RR+mjmHotlVrBVUMoGKIrEchWwIDarqhSsjLp8NbOBQ=";

  meta = {
    description = "Screen saves and visual effects for your terminal";
    homepage = "https://github.com/oiwn/tarts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.da157 ];
    mainProgram = "tarts";
  };
})
