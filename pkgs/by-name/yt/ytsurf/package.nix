{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  bash,
  coreutils,
  findutils,
  gawk,
  gnugrep,
  gnused,
  yt-dlp,
  mpv,
  chafa,
  curl,
  jq,
  fzf,
  perl,
  socat,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ytsurf";
  version = "3.1.8";

  src = fetchFromGitHub {
    owner = "Stan-breaks";
    repo = "ytsurf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mcDxWKg64ZQbdw9Mc53Zeh8/84gjckzH9o9yYqpbNkw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ bash ];

  installPhase = ''
    runHook preInstall

    install -D ytsurf.sh $out/bin/ytsurf
    wrapProgram $out/bin/ytsurf \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          findutils
          gawk
          gnugrep
          gnused
        ]
      } \
      --suffix PATH : ${
        lib.makeBinPath [
          yt-dlp
          mpv
          chafa
          curl
          jq
          fzf
          perl
          socat
        ]
      }

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Search for YouTube videos from your terminal";
    homepage = "https://github.com/Stan-breaks/ytsurf";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ytsurf";
    platforms = lib.platforms.unix;
  };
})
