{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  clang,
  ffmpeg_6-headless,
  openssl,
  alsa-lib,
  opencv,
  makeWrapper,
  mpv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tplay";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "maxcurzi";
    repo = "tplay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wAvO3iEyP7REojDo2vEjLxFXmf66vlOon5wfHTcYbXI=";
  };

  cargoHash = "sha256-8WQsHRY3bEZ/24uU93iuMs2t+i4z13C0X90Ey1WGosU=";
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
    ffmpeg_6-headless
  ];

  buildInputs = [
    openssl.dev
    alsa-lib.dev
    ffmpeg_6-headless.dev
    opencv
    mpv
  ];

  postFixup = ''
    wrapProgram $out/bin/tplay \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg_6-headless ]}"
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
