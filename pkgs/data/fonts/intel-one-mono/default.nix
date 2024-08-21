{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "intel-one-mono";
  version = "1.4.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/intel/intel-one-mono/releases/download/V${finalAttrs.version}/otf.zip";
      hash = "sha256-dO+O5mdAPHYHRbwS/F4ssWhFRBlPrT1TQJGcFzqCJ/w=";
    })
    (fetchurl {
      url = "https://github.com/intel/intel-one-mono/releases/download/V${finalAttrs.version}/ttf.zip";
      hash = "sha256-VIY1UtJdy5w/U2CylvyYDW4fv9AuDSFCJOi3jworzPA=";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/truetype/ ttf/*.ttf
    install -Dm644 -t $out/share/fonts/opentype/ otf/*.otf
    runHook postInstall
  '';

  meta = {
    description = "Intel One Mono, an expressive monospaced font family that’s built with clarity, legibility, and the needs of developers in mind";
    homepage = "https://github.com/intel/intel-one-mono";
    changelog = "https://github.com/intel/intel-one-mono/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      simoneruffini
    ];
    platforms = lib.platforms.all;
  };
})
