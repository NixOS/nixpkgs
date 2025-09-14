{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuifeed";
  version = "0.4.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-CL6cd9OfvnA5N4W3rGl7XLcnlSrh3kcqA7idxexkjA4=";
  };

  cargoHash = "sha256-A7kD46gfXWK/OlFVMULlMa7Z9Q1it9/rhGo6pjFa38k=";

  doCheck = false;

  meta = {
    description = "Terminal feed reader with a fancy UI";
    mainProgram = "tuifeed";
    homepage = "https://github.com/veeso/tuifeed";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ devhell ];
  };
}
