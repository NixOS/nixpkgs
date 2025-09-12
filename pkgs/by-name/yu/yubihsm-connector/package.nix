{
  lib,
  libusb1,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
}:

buildGoModule rec {
  pname = "yubihsm-connector";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-connector";
    rev = version;
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

  meta = with lib; {
    description = "Performs the communication between the YubiHSM 2 and applications that use it";
    homepage = "https://developers.yubico.com/yubihsm-connector/";
    maintainers = with maintainers; [ matthewcroughan ];
    license = licenses.asl20;
    mainProgram = "yubihsm-connector";
  };
}
