{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-psxA4YgrO1zg1hVL93opxxQ4VgjdmLP7KI2nkhEYmaE=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-o29DesCKOtl4aQysFOVZUm2BghkFbxBOQi02KrUJRGM=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
