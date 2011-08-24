{stdenv, fetchurl, pkgconfig, gettext, perl, perlXMLParser, intltool
, libxml2, glib}:

stdenv.mkDerivation rec {
  name = "shared-mime-info-0.90";

  src = fetchurl {
    url = "http://freedesktop.org/~hadess/${name}.tar.bz2";
    sha256 = "0113nzs2bs6vw69mxss5k3sn11bjn602jm2q0hd67pkjii5gijaj";
  };

  buildInputs = [
    pkgconfig gettext intltool perl perlXMLParser libxml2 glib
  ];

  meta = {
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
  };
}
