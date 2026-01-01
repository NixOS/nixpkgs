{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
let
<<<<<<< HEAD
  version = "1.24.27";
=======
  version = "1.24.22";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
rustPlatform.buildRustPackage {
  pname = "websurfx";
  inherit version;

  src = fetchFromGitHub {
    owner = "neon-mmd";
    repo = "websurfx";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+nd4CchLAC0QbXDCCCdeLUsTyQDXprLHkWDFSljzFLY=";
=======
    hash = "sha256-l04M2veWipVmmR4lN5+8mHpL2/16JMd3biRzEIacgac=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

<<<<<<< HEAD
  cargoHash = "sha256-mkkBJBd17Ct0xpXGK1k+TZf5GqDIUW8EgFtokTDe8Vw=";
=======
  cargoHash = "sha256-ekosi4t0InWh1c14jEe2MAWPCQ4qnqwPFvTAtAlwiuw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
