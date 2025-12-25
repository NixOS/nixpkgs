{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  rustPlatform,
  openssl,
  pkg-config,
}:
let
  version = "1.24.27";
in
rustPlatform.buildRustPackage {
  pname = "websurfx";
  inherit version;

  src = fetchFromGitHub {
    owner = "neon-mmd";
    repo = "websurfx";
    tag = "v${version}";
    hash = "sha256-+nd4CchLAC0QbXDCCCdeLUsTyQDXprLHkWDFSljzFLY=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-mkkBJBd17Ct0xpXGK1k+TZf5GqDIUW8EgFtokTDe8Vw=";

  patches = [
    # Fix to get the HOME environment variable at runtime, necessary for the module
    (fetchpatch2 {
      # https://github.com/neon-mmd/websurfx/pull/718
      url = "https://github.com/neon-mmd/websurfx/commit/7f98a13f67c7251e624ec05303971a502a0bfe7f.patch?full_index=1";
      hash = "sha256-Az23PKoe4OmM1VTRWkz2GweSUswigrLx8nBQgZY7DT4=";
    })
  ];

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
