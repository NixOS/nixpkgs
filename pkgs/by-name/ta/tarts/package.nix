{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tarts";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "oiwn";
    repo = "tarts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-whkDHgxrHkmYX6hji+z8mc964lQxllaidV8clJhvDqw=";
  };

  cargoHash = "sha256-IZyjwbx7V0kPkmD9r8qrqp4nrJg8g6tepw5bvWlLZBE=";

  meta = {
    description = "Screen saves and visual effects for your terminal";
    homepage = "https://github.com/oiwn/tarts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.da157 ];
    mainProgram = "tarts";
  };
})
