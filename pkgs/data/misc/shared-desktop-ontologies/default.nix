{stdenv, fetchurl, cmake}:

stdenv.mkDerivation {
  name = "shared-desktop-ontologies-0.2";
  src = fetchurl {
    url = mirror://sourceforge/shared-desktop-ontologies/shared-desktop-ontologies-0.2.tar.bz2;
    sha256 = "1w9gfprrp518hb7nm5wspxjd7xx0h08bph6asrx5vrx7j7fzg4m7";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "Ontologies necessary for the Nepomuk semantic desktop";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
