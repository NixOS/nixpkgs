{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "y-cruncher";
  version = "0.8.5.9543";

  src = fetchurl {
    url = "http://www.numberworld.org/y-cruncher/y-cruncher%20v${version}-static.tar.xz";
    hash = "sha256-AwbJZnvNm3SLIZpSgtYScSm4zAuFocX/NbiD87CAxog=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r y-cruncher Binaries $out/lib

    # Strip executable bit from data files
    chmod -x $out/lib/Binaries/*.txt $out/lib/Binaries/Digits/*.txt

    mkdir -p $out/bin
    ln -s $out/lib/y-cruncher $out/bin/y-cruncher

    runHook postInstall
  '';

  meta = {
    description = "Multi-threaded application to compute mathematical constants";
    homepage = "http://www.numberworld.org/y-cruncher/";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ benpye ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "y-cruncher";
  };
}
