{
  lib,
  rustPlatform,
  fetchFromCodeberg,

  makeBinaryWrapper,
  ffmpeg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yadal";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "tomkoid";
    repo = "yadal";
    tag = finalAttrs.version;
    hash = "sha256-TgM1xhk47x8Bl8gITCmM05ilZH9E29DuWBIg5bPbpyU=";
  };

  cargoHash = "sha256-pOmko/ec5YbZ47j+EnYKm5lYN1fDmmjAV62OV641Y+s=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/yadal \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = {
    description = "Yet another TIDAL Hi-Res audio downloader for the CLI";
    homepage = "https://codeberg.org/tomkoid/yadal";
    license = lib.licenses.gpl3Only;
    changelog = "https://codeberg.org/tomkoid/yadal/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ tomkoid ];
    mainProgram = "yadal";
  };
})
