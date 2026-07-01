{
  apple-sdk,
  fetchFromGitHub,
  ibtool,
  lib,
  makeBinaryWrapper,
  stdenv,
  xcbuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminal-notifier";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "julienXX";
    repo = "terminal-notifier";
    tag = finalAttrs.version;
    hash = "sha256-Hd9cI3R2nQK2deBb5CBYz4DTHAEcO4vzqtA5qZwa1Ao=";
  };

  nativeBuildInputs = [
    ibtool
    makeBinaryWrapper
    xcbuildHook
  ];

  buildInputs = [
    apple-sdk
  ];

  xcbuildFlags = [
    "-target"
    "terminal-notifier"
    "-configuration"
    "Release"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    cp -r Products/Release/terminal-notifier.app $out/Applications/
    makeWrapper \
      $out/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier \
      $out/bin/terminal-notifier \
      --chdir $out/Applications/terminal-notifier.app

    runHook postInstall
  '';

  meta = {
    description = "Send macOS User Notifications from the command-line";
    homepage = "https://github.com/julienXX/terminal-notifier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amarshall ];
    platforms = lib.platforms.darwin;
    mainProgram = "terminal-notifier";
  };
})
