{
  lib,
  fetchurl,
  makeWrapper,
  stdenv,
  undmg,
  variant ?
    if (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) then
      "arm64"
    else if (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) then
      "intel64"
    else
      "universal", # not reachable by normal means
}:

assert builtins.elem variant [
  "arm64"
  "intel64"
  "universal"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "vlc-bin-${variant}";
  version = "3.0.21";

  src = fetchurl {
    url = "http://get.videolan.org/vlc/${finalAttrs.version}/macosx/vlc-${finalAttrs.version}-${variant}.dmg";
    hash =
      {
        "arm64" = "sha256-Fd1lv2SJ2p7Gpn9VhcdMQKWJk6z/QagpWKkW3XQXgEQ=";
        "intel64" = "sha256-1DH9BRw9x68CvTE8bQXZDPYEtw7T7Fu6b9TEnvPmONk=";
        "universal" = "sha256-UDgOVvgdYw41MUJqJlq/iz3ubAgiu3yeMLUyx9aaZcA=";
      }
      .${variant};
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    makeWrapper
    undmg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    cp -r "VLC.app" $out/Applications
    makeWrapper "$out/Applications/VLC.app/Contents/MacOS/VLC" "$out/bin/vlc"

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform media player and streaming server; precompiled binary for MacOS, repacked from official website";
    homepage = "https://www.videolan.org/vlc/";
    downloadPage = "https://www.videolan.org/vlc/download-macosx.html";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "vlc";
    maintainers = with lib.maintainers; [ pcasaretto ];
    platforms = lib.systems.inspect.patternLogicalAnd (lib.systems.inspect.patterns.isDarwin) (
      ({
        "arm64" = lib.systems.inspect.patterns.isAarch64;
        "intel64" = lib.systems.inspect.patterns.isx86_64;
        "universal" = lib.systems.inspect.patterns.isDarwin;
      }).${variant}
    );
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
