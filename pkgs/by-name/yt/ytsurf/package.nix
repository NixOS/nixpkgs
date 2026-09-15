{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  yt-dlp,
  ffmpeg,
  mpv,
  chafa,
  curl,
  jq,
  xh,
  fzf,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ytsurf";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "Stan-breaks";
    repo = "ytsurf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+KoTQYQfIsVrel2ctcioVC6SCZdVn2lGblQLTW9YGIE=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  propagatedUserEnvPkgs = [
    yt-dlp
    ffmpeg
    mpv
    chafa
    curl
    jq
    xh
    fzf
  ];

  installPhase = ''
    runHook preInstall

    install -D ytsurf.sh $out/bin/${finalAttrs.meta.mainProgram}
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Search for YouTube videos from your terminal";
    homepage = "https://github.com/Stan-breaks/ytsurf";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ytsurf";
    platforms = lib.platforms.all;
  };
})
