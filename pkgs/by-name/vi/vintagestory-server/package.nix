{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dotnet-runtime_8,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "vintagestory-server";
  version = "1.21.5";

  src = fetchurl {
    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_${version}.tar.gz";
    hash = "sha256-Js9l53S2156whJlV/D3m0id+lDerEfsQaMotWJ0sygM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    dotnet-runtime_8
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out/

    makeWrapper '${lib.getExe dotnet-runtime_8}' "$out/bin/vintagestory-server" \
      --append-flags "$out/VintagestoryServer.dll"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://vintagestory.at/";
    description = "Dedicated server for Vintage Story, an in-development indie sandbox game about innovation and exploration";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    mainProgram = "VintageStoryServer";
    maintainers = with maintainers; [ cspeardev ];
  };
}
