{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "tombl";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "snyball";
    repo = "tombl";
    tag = "v${version}";
    hash = "sha256-XHvAgJ8/+ZkBxwZpMgaDchr0hBa1FXAd/j1+HH9N6qw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-A3zdDzmwX2gdTLLWnUGeiqY1R5PBKZRmEHdIi1Uveaw=";

  meta = {
    description = "Easily query TOML files from bash";
    homepage = "https://github.com/snyball/tombl";
    mainProgram = "tombl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oskardotglobal ];
  };
}
