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
}:
rustPlatform.buildRustPackage rec {
  pname = "tplay";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "maxcurzi";
    repo = "tplay";
    rev = "v${version}";
    hash = "sha256-JVkezG2bs99IFOTONeZZRljjbi0EhFf+DMxcfiWI4p4=";
  };

  cargoHash = "sha256-LHRTmjAwDPMOP6YQfL01leEzqRKtteU1cnUqL6UeWKk=";
  checkFlags = [
    # requires network access
    "--skip=pipeline::image_pipeline::tests::test_process"
    "--skip=pipeline::image_pipeline::tests::test_to_ascii"
    "--skip=pipeline::image_pipeline::tests::test_to_ascii_ext"
    "--skip=pipeline::runner::tests::test_time_to_send_next_frame"
  ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    clang
    makeWrapper
  ];

  buildInputs = [
    openssl.dev
    alsa-lib.dev
    ffmpeg_6-headless.dev
    opencv
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
}
