{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tarts";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "oiwn";
    repo = "tarts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IhK74R43ylJqT7eESY/ko/0+PfvJeJav/lERrVM0ZOA=";
  };

  cargoHash = "sha256-gMifRr9cTLIOz6jbjYDUS/JQJL/lOfYzt8w0PT9+Q+M=";

  meta = {
    description = "Screen saves and visual effects for your terminal";
    homepage = "https://github.com/oiwn/tarts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.da157 ];
    mainProgram = "tarts";
  };
})
