{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libusb1,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uni-sync";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "EightB1ts";
    repo = "uni-sync";
    rev = finalAttrs.version;
    hash = "sha256-Qf4tDj55dBHcnCiSEoWt+uwq/gTm0DSTzlOvdw3QThU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  patches = [
    ./ignore_read-only_filesystem.patch
  ];

  cargoHash = "sha256-ot2pbCddvw3njsz36WbFFJ9AAtmojUnRxlUbym1RcgU=";

  meta = with lib; {
    description = "Synchronization tool for Lian Li Uni Controllers";
    homepage = "https://github.com/EightB1ts/uni-sync";
    license = licenses.mit;
    maintainers = with maintainers; [ yunfachi ];
    mainProgram = "uni-sync";
  };
})
