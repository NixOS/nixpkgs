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
  version = "1.4.5.0";
  urlVersion = lib.replaceStrings [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${urlVersion}.zip";
    hash = "sha256-PRA7cCFL2WJlT5Bat24PSgs9rhLu4C2mu5zWbut3kdQ=";
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
