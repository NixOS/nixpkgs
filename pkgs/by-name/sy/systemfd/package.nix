{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  version = "0.4.6";

in
rustPlatform.buildRustPackage {

  pname = "systemfd";
  inherit version;

  src = fetchFromGitHub {
    repo = "systemfd";
    owner = "mitsuhiko";
    rev = version;
    sha256 = "sha256-OUsQBHymoiLClRS45KE4zsyOh/Df8psP0t8aIkKNZsM=";
  };

  cargoHash = "sha256-89yFfyByKistkzrvBqwH0FNGgnjKtvDpvDVsiWkWeKM=";

  meta = {
    description = "Convenient helper for passing sockets into another process";
    mainProgram = "systemfd";
    homepage = "https://github.com/mitsuhiko/systemfd";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };

}
