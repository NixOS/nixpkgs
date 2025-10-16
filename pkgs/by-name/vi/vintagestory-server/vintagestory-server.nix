{ lib, stdenv, fetchurl, autoPatchelfHook, dotnet-runtime_8, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "vintagestory-server";
  version = "1.21.5";

  src = fetchurl {
    url =
      "https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_${version}.tar.gz";
    sha256 = "sha256-Js9l53S2156whJlV/D3m0id+lDerEfsQaMotWJ0sygM=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ stdenv.cc.cc.lib dotnet-runtime_8 ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out/

    cat <<EOF > $out/bin/vintagestory-server
    #!/usr/bin/env bash
    cd "$out"
    exec dotnet VintagestoryServer.dll "\$@"
    EOF

    chmod +x $out/bin/vintagestory-server

    wrapProgram $out/bin/vintagestory-server \
      --prefix PATH : ${lib.makeBinPath [ dotnet-runtime_8 ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://vintagestory.at/";
    description =
      "Dedicated server for Vintage Story, an in-development indie sandbox game about innovation and exploration";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    mainProgram = "VintageStoryServer";
    maintainers = with maintainers; [ cspeardev ];
  };
}
