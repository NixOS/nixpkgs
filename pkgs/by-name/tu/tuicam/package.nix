{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  pkg-config,
  udev,
  opencv,
  llvmPackages,
  clang,
}:
rustPlatform.buildRustPackage rec {
  pname = "tuicam";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "hlsxx";
    repo = "tuicam";
    tag = "v${version}";
    hash = "sha256-IBSkMvLAUvY6v/0DxgpaA0L/mu2s/ahHQsYJjtLNmCY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-b+hAKnLImbadjGcxlktoL0yJ8ZEa7EUlIE6h+/fFg0k=";

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

  doCheck = false;

  meta = {
    description = "Terminal-based camera with switchable modes";
    homepage = "https://github.com/hlsxx/tuicam";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ linuxmobile ];
    platforms = lib.platforms.linux;
    mainProgram = "tuicam";
  };
}
