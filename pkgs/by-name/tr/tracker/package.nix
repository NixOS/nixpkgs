{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "tracker";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "ShenMian";
    repo = "tracker";
    rev = "v${version}";
    hash = "sha256-wYiimdi0l8X+CZHPY2geILpg3RTBy8LNQwU0J+cVabQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-iSbs/q2xi9+tw3twuJpZ8Xky2N4ss5bqMSq1Dx0eCT8=";

  meta = {
    description = "A terminal-based real-time satellite tracking and orbit prediction application";
    homepage = "https://github.com/ShenMian/tracker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "tracker";
  };
}
