{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "vimv-rs";
  version = "3.1.0";

  src = fetchCrate {
    inherit version;
    crateName = "vimv";
    hash = "sha256-jbRsgEsRYF5hlvo0jEB4jhy5jzCAXNzOsNWWyh4XULQ=";
  };

  cargoHash = "sha256-A+Ba3OWQDAramwin1Yc1YDOyabuEEaZGhE1gel2tFoM=";

  meta = with lib; {
    description = "Command line utility for batch-renaming files";
    homepage = "https://www.dmulholl.com/dev/vimv.html";
    license = licenses.bsd0;
    mainProgram = "vimv";
    maintainers = with maintainers; [ zowoq ];
  };
}
