{ lib, rustPlatform, fetchFromGitHub, pkg-config, wayland, libcosmic }:

rustPlatform.buildRustPackage rec {
  pname = "tomodorange";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "1dragon-xyz";
    repo = "tomodorange";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # I will update this hash
  };

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # I will update this hash

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ wayland libcosmic ];

  meta = with lib; {
    description = "Native COSMIC™ Pomodoro timer built with Rust";
    homepage = "https://github.com/1dragon-xyz/tomodorange";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ]; # You can add your nix handle here later
    platforms = platforms.linux;
  };
}
