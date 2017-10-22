{ stdenv, lib, fetchurl, libX11, libXcursor, variants ?
  [    "Black"    "Blue"    "Green"    "Orange"    "White"
    "LH-Black" "LH-Blue" "LH-Green" "LH-Orange" "LH-White" ] }:

with lib;

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "flatbed-xcursor-theme";
  version = "0.4";

  src = fetchurl {
    url = "http://www.limitland.de/downloads/flatbedcursors/FlatbedCursors-${version}.tar.bz2";
    sha256 = "0rwwdyfqikz42fl7srskr91gx8dz0iwswb4zp4lhllcyxv57g9cn";
  };
  sourceRoot = ".";

  buildInputs = [ libX11 libXcursor ];

  installPhase = ''
    mkdir -p $out/share/icons
    for theme in ${concatStringsSep " " variants}; do
      cp -R FlatbedCursors-$theme $out/share/icons/
    done
  '';

  meta = {
    description = "Flatbed X cursor theme";
    homepage = http://www.limitland.de/flatbedcursors;
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
  };
}
