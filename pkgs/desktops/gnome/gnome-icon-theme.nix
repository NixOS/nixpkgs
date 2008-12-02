{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser
, iconnamingutils, gettext, intltool
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [intltool pkgconfig perl perlXMLParser iconnamingutils gettext ];

  # the ln line can be removed because pkgconfig adds both locations
  postInstall = "
    ensureDir $out/lib
    ln -s $out/share/pkgconfig $out/lib/pkgconfig # WTF?
  ";  
}
