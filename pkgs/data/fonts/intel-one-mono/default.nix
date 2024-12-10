{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "intel-one-mono";
  version = "1.3.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/intel/intel-one-mono/releases/download/V${finalAttrs.version}/otf.zip";
      hash = "sha256-iZIfkXH+GplVwES4LaQBIaCWs7OKmEto9J2SpzvagSs=";
    })
    (fetchurl {
      url = "https://github.com/intel/intel-one-mono/releases/download/V${finalAttrs.version}/ttf.zip";
      hash = "sha256-EeUTEMuoTHKmuO5Uj0jjiDRF9t7jxbIy45nTWozlgfc=";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/truetype/ ttf/*.ttf
    install -Dm644 -t $out/share/fonts/opentype/ otf/*.otf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Intel One Mono, an expressive monospaced font family that’s built with clarity, legibility, and the needs of developers in mind";
    homepage = "https://github.com/intel/intel-one-mono";
    changelog = "https://github.com/intel/intel-one-mono/releases/tag/V${finalAttrs.version}";
    license = licenses.ofl;
    maintainers = [ maintainers.simoneruffini ];
    platforms = platforms.all;
  };
})
