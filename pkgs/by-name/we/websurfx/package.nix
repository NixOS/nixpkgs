{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
let
  version = "1.24.36";
in
rustPlatform.buildRustPackage {
  pname = "websurfx";
  inherit version;

  src = fetchFromGitHub {
    owner = "neon-mmd";
    repo = "websurfx";
    tag = "v${version}";
    hash = "sha256-Iw/wG6IKp+KdBVhmC/wVU55h9B/Ew8qrb4ZrMfVF+Ic=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-S8XGsOfYK1Ua2rCt7kKyLKXMXs1G1G7M6kqJ9UcdBjc=";

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
