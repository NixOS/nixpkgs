{
  fetchzip,
  lib,
  makeBinaryWrapper,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminal-notifier";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/alloy/terminal-notifier/releases/download/${finalAttrs.version}/terminal-notifier-${finalAttrs.version}.zip";
    hash = "sha256-YMFO/pg41FDXBrqdwpgxGkDUii5zfNp9ni5EKNImJT4=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    cp -r terminal-notifier.app $out/Applications
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
