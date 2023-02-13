{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, udev }:

rustPlatform.buildRustPackage rec {
  pname = "elf2uf2-rs";
  version = "1.3.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-2ZilZIYXCNrKJlkHBsz/2/pMtF+UDfjDlt53ylcwgus=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  cargoSha256 = "sha256-+3Rqlzkrw9XfM3PelGNbnRGaWQLbzVJ7iJgvGgVt5FE=";

  meta = with lib; {
    description = "Convert ELF files to UF2 for USB Flashing Bootloaders";
    homepage = "https://github.com/JoNil/elf2uf2-rs";
    license = with licenses; [ bsd0 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ polygon ];
  };
}
