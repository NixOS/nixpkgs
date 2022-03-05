{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, udev }:

rustPlatform.buildRustPackage rec {
  pname = "elf2uf2-rs";
  version = "unstable-2021-12-12";

  src = fetchFromGitHub {
    owner = "JoNil";
    repo = pname;
    rev = "91ae98873ed01971ab1543b98266a5ad2ec09210";
    sha256 = "sha256-DGrT+YdDLdTYy5SWcQ+DNbpifGjrF8UTXyEeE/ug564=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  cargoSha256 = "sha256-5ui1+987xICP2wUSHy4YzKskn52W51Pi4DbEh+GbSPE=";

  meta = with lib; {
    description = "Convert ELF files to UF2 for USB Flashing Bootloaders";
    homepage = "https://github.com/JoNil/elf2uf2-rs";
    license = with licenses; [ bsd0 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ polygon ];
  };
}
