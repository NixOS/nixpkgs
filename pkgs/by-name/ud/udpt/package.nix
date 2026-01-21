{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "udpt";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "naim94a";
    repo = "udpt";
    rev = "v${version}";
    sha256 = "sha256-dWZRl5OiuEmCx7+Id0/feCohH5k/HA47nbPUEo8BBwQ=";
  };

  cargoHash = "sha256-AtqtANpxsmvdEoISyGZKDVR7/IxMBPwGGNelgf7ZlH4=";

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
