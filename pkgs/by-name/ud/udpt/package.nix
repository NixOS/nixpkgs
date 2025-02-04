{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "udpt";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "naim94a";
    repo = "udpt";
    rev = "v${version}";
    sha256 = "sha256-dWZRl5OiuEmCx7+Id0/feCohH5k/HA47nbPUEo8BBwQ=";
  };

  cargoHash = "sha256-wOBD8XKlIpLqj5R8rOw6m4V/UAFiPodo+P32mvjA8Go=";

  postInstall = ''
    install -D udpt.toml $out/share/udpt/udpt.toml
  '';

  meta = {
    description = "Lightweight UDP torrent tracker";
    homepage = "https://naim94a.github.io/udpt";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "udpt-rs";
  };
}
