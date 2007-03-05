{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser
, iconnamingutils, gettext
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl perlXMLParser iconnamingutils gettext];

  postInstall = "
    ensureDir $out/lib
    ln -s $out/share/pkgconfig $out/lib/pkgconfig # WTF?
  ";  
}
