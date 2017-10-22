{ stdenv, lib, fetchurl, libX11, libXcursor, variants ?
  [      "Black"      "Blue"      "Green"      "Orange"      "Red"      "White"
    "Slim-Black" "Slim-Blue" "Slim-Green" "Slim-Orange" "Slim-Red" "Slim-White" ] }:

with lib;

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "comix-xcursor-theme";
  version = "0.9.0";

  src = fetchurl {
    url = "http://www.limitland.de/downloads/comixcursors/ComixCursors-${version}.tar.bz2";
    sha256 = "0j16pihx39kqzw4zyzdlc6qhd1sb8q0kpprz2zz0wia36wvdgsci";
  };
  sourceRoot = ".";

  buildInputs = [ libX11 libXcursor ];

  installPhase = ''
    mkdir -p $out/share/icons
    for theme in ${concatStringsSep " " variants}; do
      cp -R ComixCursors-$theme $out/share/icons/
    done
  '';

  meta = {
    description = "Comix X cursor theme";
    homepage = http://www.limitland.de/comixcursors;
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
  };
}
