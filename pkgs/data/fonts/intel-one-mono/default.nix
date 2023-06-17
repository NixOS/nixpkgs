{ lib, stdenvNoCC, fetchurl, unzip}:

stdenvNoCC.mkDerivation rec {
  pname = "intel-one-mono";
  version = "1.2.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/intel/intel-one-mono/releases/download/V${version}/otf.zip";
      sha256 = "sha256-VnXIaW77dRXvXB1Vr01xRQDMECltwzF/RMqGgAWnu5M=";
     })
    (fetchurl {
      url = "https://github.com/intel/intel-one-mono/releases/download/V${version}/ttf.zip";
      sha256 = "sha256-kaz0DePeO8nvKVonYJhs5f2+ps/5Xo5psjg1hoxzaiU=";
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
    changelog = "https://github.com/intel/intel-one-mono/releases/tag/V${version}";
    license = licenses.ofl;
    maintainers = [ maintainers.simoneruffini];
    platforms = platforms.all;
  };
}
