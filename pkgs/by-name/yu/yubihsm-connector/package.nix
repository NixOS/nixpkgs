{
  lib,
  libusb1,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "yubihsm-connector";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-connector";
    rev = finalAttrs.version;
    hash = "sha256-hiCh/TG1epSmJtaptfVzcPklDTaBh0biKqfM01YoWo0=";
  };

  vendorHash = "sha256-XW7rEHY3S+M3b6QjmINgrCak+BqCEV3PJP90jz7J47A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  preBuild = ''
    GOOS= GOARCH= go generate
  '';

  meta = {
    description = "Performs the communication between the YubiHSM 2 and applications that use it";
    homepage = "https://developers.yubico.com/yubihsm-connector/";
    maintainers = with lib.maintainers; [ matthewcroughan ];
    license = lib.licenses.asl20;
    mainProgram = "yubihsm-connector";
  };
})
