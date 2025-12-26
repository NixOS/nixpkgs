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
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "hlsxx";
    repo = "tuicam";
    tag = "v${version}";
    hash = "sha256-Ry64sd0OYGqbiVqveU05gsmf1c9kQy2QMN9Z5seMedc=";
  };

  cargoHash = "sha256-z+5fVSl9zFdOFNCCf49iVltAm+rZcJtLsz+zLCUlC6o=";

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
    maintainers = with lib.maintainers; [ FKouhai ];
    platforms = lib.platforms.linux;
    mainProgram = "tuicam";
  };
}
