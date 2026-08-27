{
  fetchFromGitHub,
  ibtool,
  lib,
  makeBinaryWrapper,
  stdenv,
  xcbuildHook,
  rcodesign,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminal-notifier";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "julienXX";
    repo = "terminal-notifier";
    tag = finalAttrs.version;
    hash = "sha256-VnXGC8Yq7WoLPPMyn0MdwJ+evCk3lDoSznDF+MJI2lM=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    ibtool
    makeBinaryWrapper
    xcbuildHook
  ];

  xcbuildFlags = [
    "-target"
    "terminal-notifier"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Products/Release/terminal-notifier.app $out/Applications/

    makeWrapper \
      $out/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier \
      $out/bin/terminal-notifier

    runHook postInstall
  '';

  # Notifications require that the app bundle be codesigned (beyond the linker-signing that happens automatically for the executable)
  postFixup = ''
    ${lib.getExe rcodesign} sign "$out/Applications/terminal-notifier.app"
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
