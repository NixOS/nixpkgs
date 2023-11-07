{
  lib,
  pkg-config,
  openssl,
  opencv,
  clang,
  libclang,
  ffmpeg,
  alsa-lib,
  fetchFromGitHub,
  rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tplay";
  version = "0.45";

  src = fetchFromGitHub {
    owner = "maxcurzi";
    repo = pname;
    rev =  "v${version}";
    hash = "sha256-qt5I5rel88NWJZ6dYLCp063PfVmGTzkUUKgF3JkhLQk=";
  };

  cargoHash = "sha256-jgUKGV2Yg8+iF2wQZd1Z+QFfyJmywVTFVECUs+TK8zA=";
  cargoPatches = [ ./cargo.diff ];
  doCheck = false;

  buildInputs = [
    openssl.dev
    alsa-lib.dev
    libclang.lib
    ffmpeg.dev
    opencv
  ];

  nativeBuildInputs = [
    pkg-config
    clang
  ];

  env.LIBCLANG_PATH = "${libclang.lib}/lib";

  meta = {
    description = "Terminal Media Player";
    homepage = "https://github.com/maxcurzi/tplay";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [  ];
  };
}
