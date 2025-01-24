{
  bash,
  coreutils-prefixed,
  curl,
  fetchFromGitHub,
  gnused,
  gnugrep,
  installShellFiles,
  jq,
  lib,
  makeWrapper,
  mplayer,
  mpv,
  procps,
  scdoc,
  stdenvNoCC,
  streamlink,
  vlc,
  fzf,
  withMpv ? true,
  withVlc ? false,
  withMplayer ? false,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wtwitch";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "krathalan";
    repo = "wtwitch";
    tag = finalAttrs.version;
    hash = "sha256-2YLBuxGwGkav3zB2qMqM6yRXf7ZLqgULoJV4s5p+hSw=";
  };

  # hardcode SCRIPT_NAME because #150841
  postPatch = ''
    substituteInPlace src/wtwitch --replace 'readonly SCRIPT_NAME="''${0##*/}"' 'readonly SCRIPT_NAME="wtwitch"'
  '';

  buildPhase = ''
    runHook preBuild

    scdoc < src/wtwitch.1.scd > wtwitch.1

    runHook postBuild
  '';

  nativeBuildInputs = [
    scdoc
    installShellFiles
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    installManPage wtwitch.1
    installShellCompletion --cmd wtwitch \
      --bash src/wtwitch-completion.bash \
      --zsh src/_wtwitch
    install -Dm755 src/wtwitch $out/bin/wtwitch
    wrapProgram $out/bin/wtwitch \
      --set-default LANG en_US.UTF-8 \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            bash
            coreutils-prefixed
            curl
            gnused
            gnugrep
            jq
            procps
            streamlink
            fzf
          ]
          ++ lib.optional withMpv mpv
          ++ lib.optional withVlc vlc
          ++ lib.optional withMplayer mplayer
        )
      }

    runHook postInstall
  '';

  meta = {
    description = "Terminal user interface for Twitch";
    homepage = "https://github.com/krathalan/wtwitch";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.urandom ];
    platforms = lib.platforms.all;
    mainProgram = "wtwitch";
  };
})
