{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  clang,
  ffmpeg,
  openssl,
  alsa-lib,
  libclang,
  opencv,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "tplay";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "maxcurzi";
    repo = "tplay";
    rev = "v${version}";
    hash = "sha256-/3ui0VOxf+kYfb0JQXPVbjAyXPph2LOg2xB0DGmAbwc=";
  };

  cargoHash = "sha256-zRkIEH37pvxHUbnfg25GW1Z7od9XMkRmP2Qvs64uUjg=";
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
    libclang.lib
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
