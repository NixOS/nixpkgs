{stdenv, fetchurl, perl, perlXMLParser, pkgconfig, gettext, libxml2, glib}:

stdenv.mkDerivation {
  name = "shared-mime-info-0.21";

  src = fetchurl {
	url = http://FIX_ME.org/shared-mime-info-0.21.tar.bz2;
    sha256 = "050jyvnhwv0fdyfmdb8sdxkryw0vqnkkzz7ld6jl4ixiv2ikcnhk";
  };

  buildInputs = [perl perlXMLParser pkgconfig gettext libxml2 glib];
}
