{stdenv, fetchurl, perl, perlXMLParser, pkgconfig, gettext, libxml2, glib}:

stdenv.mkDerivation {
  name = "shared-mime-info-0.22";

  src = fetchurl {
	url = http://freedesktop.org/~hadess/shared-mime-info-0.22.tar.bz2;
    sha256 = "1chz63v9jr009z9jhs07klybmhyf58i8vxipigf5gkdabjiclcyr";
  };

  buildInputs = [perl perlXMLParser pkgconfig gettext libxml2 glib];
}
