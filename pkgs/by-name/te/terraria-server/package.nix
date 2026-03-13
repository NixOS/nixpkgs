{
  lib,
  stdenv,
  fetchurl,

  autoPatchelfHook,
  unzip,
  sdl3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terraria-server";
  version = "1.4.5.5";
  urlVersion = lib.replaceStrings [ "." ] [ "" ] finalAttrs.version;

  src = fetchurl {
    url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${finalAttrs.urlVersion}.zip";
    hash = "sha256-BmLT5ATBviSfYuc3Cx/aMHUNTBs6S56GHJF8YIJXhtU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    stdenv.cc.cc.libgcc
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r Linux $out/
    chmod +x "$out/Linux/TerrariaServer.bin.x86_64"
    ln -s "$out/Linux/TerrariaServer.bin.x86_64" $out/bin/TerrariaServer

    # use our own SDL3 library
    rm $out/Linux/lib64/libSDL3.so.0
    ln -s ${lib.getLib sdl3}/lib/libSDL3.so.0 $out/Linux/lib64/libSDL3.so.0

    runHook postInstall
  '';

  meta = {
    homepage = "https://terraria.org";
    description = "Dedicated server for Terraria, a 2D action-adventure sandbox";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "TerrariaServer";
    maintainers = with lib.maintainers; [
      tomasajt
    ];
  };
})
