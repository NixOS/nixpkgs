{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, clang
, ffmpeg
, openssl
, alsa-lib
, libclang
, opencv
}:
rustPlatform.buildRustPackage rec {
  pname = "tplay";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "maxcurzi";
    repo = "tplay";
    rev =  "v${version}";
    hash = "sha256-qt5I5rel88NWJZ6dYLCp063PfVmGTzkUUKgF3JkhLQk=";
  };

  cargoHash = "sha256-0kHh7Wb9Dp+t2G9/Kz/3K43bQdFCl+q2Vc3W32koc2I=";
  cargoPatches = [ ./cargo.diff ];
  checkFlags = [
        # requires network access
    "--skip=pipeline::image_pipeline::tests::test_process"
    "--skip=pipeline::image_pipeline::tests::test_to_ascii"
    "--skip=pipeline::image_pipeline::tests::test_to_ascii_ext"
    "--skip=pipeline::runner::tests::test_time_to_send_next_frame"
  ];

  nativeBuildInputs = [ pkg-config clang ffmpeg ];
  buildInputs = [
    openssl.dev
    alsa-lib.dev
    libclang.lib
    ffmpeg.dev
    opencv
  ];

  env.LIBCLANG_PATH = "${libclang.lib}/lib";

  meta = {
    description = "Terminal Media Player";
    homepage = "https://github.com/maxcurzi/tplay";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ demine ];
  };
}
