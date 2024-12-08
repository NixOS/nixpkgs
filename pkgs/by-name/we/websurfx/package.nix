{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
let
  version = "1.20.13";
in
rustPlatform.buildRustPackage {
  pname = "websurfx";
  inherit version;

  src = fetchFromGitHub {
    owner = "neon-mmd";
    repo = "websurfx";
    rev = "refs/tags/v${version}";
    hash = "sha256-NuhSpUe1PzJTBsX91LSOIh4N20eTs7MLl4ueIoGoC6o=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  useFetchCargoVendor = true;

  cargoHash = "sha256-SRRZoK7zsSDTvOyqJ+YLNkhzTseAgK0KGCoAECmuDa8=";

  postPatch = ''
    substituteInPlace src/handler/mod.rs \
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
