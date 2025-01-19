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

  cargoHash = "sha256-rYQxIttuGBGEkYkFtSBl8ce1I/Akm6FxeITJcaIeP6M=";

  meta = {
    description = "Command line utility for batch-renaming files";
    homepage = "https://www.dmulholl.com/dev/vimv.html";
    license = lib.licenses.bsd0;
    mainProgram = "vimv";
    maintainers = with lib.maintainers; [ zowoq ];
  };
}
