{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  clang,
  ffmpeg,
  openssl,
  alsa-lib,
  opencv,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "tplay";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "maxcurzi";
    repo = "tplay";
    rev = "v${version}";
    hash = "sha256-SRn7kg5FdSimKMFowKNUIan+MrojtNO0apeehIRTzfw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SzOx9IPp+TjiJpAEX8+GhZ+UEEmqNpI67S40OiYrHfM=";
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
    ffmpeg
    makeWrapper
  ];

  buildInputs = [
    openssl.dev
    alsa-lib.dev
    ffmpeg.dev
    opencv
  ];

  postFixup = ''
    wrapProgram $out/bin/tplay \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"
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
