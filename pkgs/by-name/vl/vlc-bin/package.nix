{
  lib,
  fetchurl,
  makeWrapper,
  stdenv,
  undmg,
  variant ? if stdenv.hostPlatform.isDarwin then "arm64" else "universal", # not reachable by normal means
}:

assert builtins.elem variant [
  "arm64"
  "universal"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "vlc-bin-${variant}";
  version = "3.0.23";

  src = fetchurl {
    url = "http://get.videolan.org/vlc/${finalAttrs.version}/macosx/vlc-${finalAttrs.version}-${variant}.dmg";
    hash =
      {
        "arm64" = "sha256-/G+sCNh/U4UX1ErKDF56JEtnyMTLWJv0eDY6cxX9Xg0=";
        "universal" = "sha256-Vu5lfDqvXHG0q31uT0p39uylRjPgv0KpO4EW6x0fbsk=";
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
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
