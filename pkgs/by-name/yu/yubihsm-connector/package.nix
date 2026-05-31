{
  lib,
  libusb1,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "yubihsm-connector";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-connector";
    rev = finalAttrs.version;
    hash = "sha256-ddf8IamX8wC8IG9puFDoSKsVqc9KE/LtsJ0Wk0FFquw=";
  };

  # Don't run go generate in the module fetching
  overrideModAttrs = _: {
    preBuild = null;
  };

  vendorHash = "sha256-vtIXFOptDbBKjnDUSD9ng5tnfYQ3lklwgcEUvKMdCOM=";

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

  doInstallCheck = true;
  installCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Performs the communication between the YubiHSM 2 and applications that use it";
    homepage = "https://developers.yubico.com/yubihsm-connector/";
    maintainers = with lib.maintainers; [
      matthewcroughan
      numinit
    ];
    license = lib.licenses.asl20;
    mainProgram = "yubihsm-connector";
  };
})
