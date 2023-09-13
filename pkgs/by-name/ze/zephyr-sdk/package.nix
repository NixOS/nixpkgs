{ lib
, stdenv
, fetchurl
, python38
, autoPatchelfHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zephyr-sdk";
  version = "0.16.1";

  src = let
    inherit (finalAttrs) version;
  in builtins.getAttr stdenv.hostPlatform.system {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${version}/zephyr-sdk-${version}_linux-x86_64.tar.xz";
      hash = "sha256-UTONUapM6iUWZBzg2dwLUbdjd58A3EVkorwN1xPfIsc=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${version}/zephyr-sdk-${version}_linux-aarch64.tar.xz";
      hash = "sha256-BiuytcR8pW3Sm3+S3X8Hpc4iulE3WdK2lgvGWFMesAw=";
    };
  };

  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc
    python38
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/zephyrproject-rtos/sdk-ng";
    description = "Collection of compilers and tools for the Zephyr RTOS";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ mib ];
    sourceProvenance = with sourceTypes; [
      binaryFirmware
      binaryNativeCode
    ];
  };
})
