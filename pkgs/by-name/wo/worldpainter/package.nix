{
  lib,
  stdenv,
  fetchurl,
  jre,
  gnused,
}:

stdenv.mkDerivation rec {
  pname = "worldpainter";
  version = "2.22.1";

  src = fetchurl {
    url = "https:/www.worldpainter.net/files/${pname}_${version}.tar.gz";
    hash = "sha256-nvHMOXAzAywUysAtD9Rrovot1kh9VqzGw/79FcfxAy4=";
  };

  buildInputs = [
    jre
    gnused
  ];

  outputs = [ "out" ];

  installPhase = ''
    mkdir -p $out/{bin,lib,.install4j/user}

    install -Dm644 bin/*        "$out/bin/"
    install -Dm644 lib/*        "$out/lib/"
    install -Dm644 *.vmoptions  "$out/"
    install -Dm755 worldpainter "$out/"
    install -Dm755 wpscript     "$out/"
    find .install4j/ -maxdepth 1 -type f -exec install -Dm644 {} "$out/.install4j/" \;
	  find .install4j/user/ -maxdepth 1 -type f -exec install -Dm644 {} "$out/.install4j/user/" \;

    mkdir -p $out/share/{pixmaps,applications}
    install -D -m 644 ${./worldpainter.png} $out/share/pixmaps/worldpainter.png
    install -D -m 644 ${./worldpainter.desktop} $out/share/applications/worldpainter.desktop
    echo "Exec=$out/worldpainter" >> $out/share/applications/worldpainter.desktop
    echo "Icon=$out/share/pixmaps/worldpainter.png" >> $out/share/applications/worldpainter.desktop
    '';

  postPatch = ''
    sed -i '2s|^|PATH="${jre}/bin":$PATH|' worldpainter
    sed -i '2s|^|PATH="${jre}/bin":$PATH|' wpscript

  '';

  meta = {
    homepage = "https:/www.worldpainter.net/";
    description = "WorldPainter is an interactive map generator for Minecraft. It allows you to \"paint\" landscapes using similar tools as a regular paint program. Sculpt and mould the terrain, paint materials, trees, snow and ice, etc. onto it, and much more";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
  };
}
