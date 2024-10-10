{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  udev,
}:
rustPlatform.buildRustPackage rec {
  pname = "ttysvr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cxreiff";
    repo = "ttysvr";
    rev = "refs/tags/v${version}";
    hash = "sha256-B99YXXgWIRDcALpM2UeiXmvNvs/wRhYovRbwH90oMU4=";
  };
  cargoHash = "sha256-FAhC7mxhoGEpAtxRQkYVovz1eh2j4q+2ttymrzmBsvw=";

  # buildFeatures = [ "bevy/x11" ];

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    udev
  ];

  noCheck = true;

  meta = {
    description = "Screen saver for your terminal";
    homepage = "https://github.com/cxreiff/ttysvr";
    changelog = "https://github.com/cxreiff/ttysvr/releases";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ griffi-gh ];
    mainProgram = "ttysvr";
    platforms = with lib.platforms; linux;
  };
}
