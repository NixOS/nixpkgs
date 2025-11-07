{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  gnused,
}:
stdenv.mkDerivation rec {
  pname = "worldpainter";
  version = "2.26.1";

  src = fetchurl {
    url = "https://www.worldpainter.net/files/${pname}_${version}.tar.gz";
    hash = "sha256-YlFiGim9IeurDZ4H1XzxRDn7GM/U/zL9SqTUT4gJdno=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    gnused
  ];

  outputs = [ "out" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib,.install4j/user}

    install -Dm644 bin/*        "$out/bin/"
    install -Dm644 lib/*        "$out/lib/"
    install -Dm644 *.vmoptions  "$out/"
    install -Dm755 worldpainter "$out/bin"
    install -Dm755 wpscript     "$out/bin"
    find .install4j/ -maxdepth 1 -type f -exec install -Dm644 {} "$out/.install4j/" \;
    find .install4j/user/ -maxdepth 1 -type f -exec install -Dm644 {} "$out/.install4j/user/" \;

    mkdir -p $out/share/{pixmaps,applications}
    install -Dm644 .install4j/i4j_extf_8_jed6s0_1y6kkxa.png   "$out/share/pixmaps/worldpainter.png"
    runHook postInstall
  '';

  postInstall = ''
    sed -i 's/app_home=\./app_home=../' $out/bin/worldpainter
    sed -i 's/app_home=\./app_home=../' $out/bin/wpscript
    wrapProgram $out/bin/worldpainter --prefix PATH : "${jre}/bin"
    wrapProgram $out/bin/wpscript --prefix PATH : "${jre}/bin"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = pname;
      exec = pname;
      icon = pname;
      terminal = false;
      type = "Application";
      startupWMClass = pname;
      comment = "Paint your own Minecraft worlds";
      categories = [ "Game" ];
    })
  ];

  meta = {
    homepage = "https://www.worldpainter.net/";
    description = "Interactive map generator for Minecraft";
    longDescription = "WorldPainter is an interactive map generator for Minecraft. It allows you to \"paint\" landscapes using similar tools as a regular paint program. Sculpt and mould the terrain, paint materials, trees, snow and ice, etc. onto it, and much more";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
