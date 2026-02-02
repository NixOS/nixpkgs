{
  lib,
  stdenv,
  fetchurl,

  autoPatchelfHook,
  unzip,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "terraria-server";
  version = "1.4.5.3";
  urlVersion = lib.replaceStrings [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${urlVersion}.zip";
    hash = "sha256-5W6XpGaWQTs9lSy1UJq60YR6mfvb3LTts9ppK05XNCg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];
  buildInputs = [
    stdenv.cc.cc.libgcc
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r Linux $out/
    chmod +x "$out/Linux/TerrariaServer.bin.x86_64"
    ln -s "$out/Linux/TerrariaServer.bin.x86_64" $out/bin/TerrariaServer

    runHook postInstall
  '';

  meta = {
    homepage = "https://terraria.org";
    description = "Dedicated server for Terraria, a 2D action-adventure sandbox";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "TerrariaServer";
    maintainers = with lib.maintainers; [
      ncfavier
      tomasajt
    ];
  };
}
