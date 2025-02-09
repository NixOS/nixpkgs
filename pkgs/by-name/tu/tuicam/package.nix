{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  pkg-config,
  udev,
  opencv,
  clang,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "tuicam";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "hlsxx";
    repo = "tuicam";
    tag = "v${version}";
    hash = "sha256-4Ae9SIhKNIdHReQbAwZbxErBA66Y7IxKj5M4kEFrplA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Mvf5isXN8DQhL8fpYUn0seAFlqVeBF8apaL7RQqtjmU=";

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    clang
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    opencv
  ];

  # Test require Camera Hardware
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based camera with switchable modes";
    homepage = "https://github.com/hlsxx/tuicam";
    changelog = "https://github.com/hlsxx/tuicam/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ linuxmobile ];
    platforms = lib.platforms.linux;
    mainProgram = "tuicam";
  };
}
