{
  unzip,
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "yandex-ffmpeg-codecs";
  version = "0.90.0";

  src = fetchurl {
    url = "https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/download/${version}/${version}-linux-x64.zip";
    hash = "sha256-AAKV896AuOm9dMV98tkEdHIpdUOSBx1QKyPR01VpqSw=";
  };

  nativeBuildInputs = [ unzip ];

  dontStrip = true;
  stripDebugList = [ "." ];

  unpackPhase = ''
    mkdir $TMP/ffmpeg-codecs/ $out/lib/ -p
    unzip -X -d $TMP/ffmpeg-codecs/ $src
  '';

  installPhase = ''
    runHook preInstall

    install -vD $TMP/ffmpeg-codecs/libffmpeg.so $out/lib/libffmpeg.so

    runHook postInstall
  '';

  meta = with lib; {
    description = "Additional support for proprietary codecs for Yandex Browser";
    homepage = "https://ffmpeg.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = [
      licenses.lgpl21
      licenses.gpl2
    ];
    maintainers = with maintainers; [ ionutnechita ];
    platforms = [ "x86_64-linux" ];
  };
}
