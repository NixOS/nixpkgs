{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  clang,
  ffmpeg-headless,
  openssl,
  alsa-lib,
  makeWrapper,
  mpv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tplay";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "maxcurzi";
    repo = "tplay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xil60rQWLPpDpXTUES3hbO4I04M1H6kffu00teczjiQ=";
  };

  cargoHash = "sha256-Ce5H1rUfZEoo6Wt7VZM1EIolQWJ8etCY+WDvqx/3L0k=";
  checkFlags = [
    # requires network access
    "--skip=pipeline::image_pipeline::tests::test_process"
    "--skip=pipeline::image_pipeline::tests::test_to_ascii"
    "--skip=pipeline::image_pipeline::tests::test_to_ascii_ext"
    "--skip=pipeline::runner::tests::test_time_to_send_next_frame"
    "--skip=pipeline::runner::tests::test_playback_speed_affects_frame_duration"
    "--skip=pipeline::runner::tests::test_playback_speed_clamping"
  ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    clang
    makeWrapper
    ffmpeg-headless
  ];

  buildInputs = [
    openssl
    alsa-lib
    ffmpeg-headless
    mpv
  ];

  postFixup = ''
    wrapProgram $out/bin/tplay \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg-headless ]}"
  '';

  meta = {
    description = "Terminal Media Player";
    homepage = "https://github.com/maxcurzi/tplay";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      demine
      colemickens
    ];
  };
})
