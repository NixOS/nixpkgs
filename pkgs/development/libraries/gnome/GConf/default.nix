{input, stdenv, fetchurl, pkgconfig, perl, glib, gtk, libxml2, ORBit2, popt}:

assert pkgconfig != null && perl != null
  && glib != null && gtk != null
  && libxml2 != null && ORBit2 != null && popt != null;

stdenv.mkDerivation {
  inherit (input) name src;

  # Perl is not `supposed' to be required, but it is.
  buildInputs = [pkgconfig perl glib gtk libxml2 popt];
  propagatedBuildInputs = [ORBit2];
}
