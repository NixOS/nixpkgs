{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thokr";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "thatvegandev";
    repo = "thokr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ms90Eo2Bk9+QTOZv9fc73gQ1xwDntTbiwXsifF79ELE=";
  };

  cargoHash = "sha256-U0nClfSQnliQEVX/PrG4B+TLqHNbL0xvttLukEGFKeI=";

  meta = {
    description = "Typing tui with visualized results and historical logging";
    homepage = "https://github.com/thatvegandev/thokr";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "thokr";
  };
})
