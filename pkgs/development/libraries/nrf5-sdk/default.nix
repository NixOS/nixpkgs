{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "nrf5-sdk";
  version = "17.1.0";

  urlHash = "ddde560";

  src = fetchzip {
    url = "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/sdks/nrf5/binaries/nrf5_sdk_${version}_${urlHash}.zip";
    sha256 = "sha256-q4WQ7X7/z/42/qcii+mOLnobqcbUy0tInkOfRH/Gwus=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nRF5_SDK
    mv * $out/share/nRF5_SDK
    rm $out/share/nRF5_SDK/*.msi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Nordic Semiconductor nRF5 Software Development Kit";
    homepage = "https://www.nordicsemi.com/Products/Development-software/nRF5-SDK";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ stargate01 ];
  };
}
