{ stdenv
, lib
, fetchurl
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, jre
, libGL
, libpulseaudio
, libXxf86vm
}:
let
  desktopItem = makeDesktopItem {
    name = "unciv";
    exec = "unciv";
    comment = "An open-source Android/Desktop remake of Civ V";
    desktopName = "Unciv";
    categories = [ "Game" ];
  };

  envLibPath = lib.makeLibraryPath (lib.optionals stdenv.isLinux [
    libGL
    libpulseaudio
    libXxf86vm
  ]);

in
stdenv.mkDerivation rec {
  pname = "unciv";
  version = "4.10.19";

  src = fetchurl {
    url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
    hash = "sha256-f9fg2Clz9CjoC8xzCguJ2A3Aczom+KjEyIlMJC2oS/o=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/unciv \
      --prefix LD_LIBRARY_PATH : "${envLibPath}" \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --add-flags "-jar ${src}"

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "An open-source Android/Desktop remake of Civ V";
    mainProgram = "unciv";
    homepage = "https://github.com/yairm210/Unciv";
    maintainers = with maintainers; [ tex ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
