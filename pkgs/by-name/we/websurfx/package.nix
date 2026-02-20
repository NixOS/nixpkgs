{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
let
  version = "1.24.47";
in
rustPlatform.buildRustPackage {
  pname = "websurfx";
  inherit version;

  src = fetchFromGitHub {
    owner = "neon-mmd";
    repo = "websurfx";
    tag = "v${version}";
    hash = "sha256-CIGq1uQl5RcxzoX7mnruFDNlgP5RlVLT6/e2ClGaQGE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-8zp8qsD2D9wSaeXY2JQuP4evXFDASOwMeOYe3HbHYp4=";

  postPatch = ''
    substituteInPlace src/handler.rs \
      --replace-fail "/etc/xdg" "$out/etc/xdg" \
      --replace-fail "/opt/websurfx" "$out/opt/websurfx"
  '';

  postInstall = ''
    mkdir -p $out/etc/xdg
    mkdir -p $out/opt/websurfx

    cp -r websurfx $out/etc/xdg/
    cp -r public $out/opt/websurfx/
  '';

  meta = {
    description = "Open source alternative to searx";
    longDescription = ''
      An open source alternative to searx which provides a modern-looking,
      lightning-fast, privacy respecting, secure meta search engine.
    '';
    homepage = "https://github.com/neon-mmd/websurfx";
    changelog = "https://github.com/neon-mmd/websurfx/releases";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "websurfx";
  };
}
