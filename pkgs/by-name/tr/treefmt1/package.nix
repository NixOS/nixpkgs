{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-icAe54Mv1xpOjUPSk8QDZaMk2ueNvjER6UyJ9uyUL6s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OLKqfAYHGgEkjU5lVkbuH2eVZIZ3cw9w9n4/MkqbX/8=";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimbatm ];
    mainProgram = "treefmt";
  };
}
