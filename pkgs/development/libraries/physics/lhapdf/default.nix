{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "lhapdf-${version}";
  version = "6.2.0";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/lhapdf/LHAPDF-${version}.tar.gz";
    sha256 = "005jfapdj3mmk62p9qgvw7nyg93pqy249p1xy2ws1qx42xj76lih";
  };

  buildInputs = [ python2 ];

  enableParallelBuilding = true;

  passthru = {
    pdf_sets = import ./pdf_sets.nix { inherit stdenv fetchurl; };
  };

  meta = {
    description = "A general purpose interpolator, used for evaluating Parton Distribution Functions from discretised data files";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = http://lhapdf.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
