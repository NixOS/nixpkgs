{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, gettext, libxslt
}:

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.GConf gnome.gnomedocutils
    gnome.gtk gnome.libgnome gnome.libgnomeui gettext libxslt
  ];

  configureFlags = "--disable-scrollkeeper";
}
