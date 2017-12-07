{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "lhapdf-${version}";
  version = "6.2.0";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/lhapdf/LHAPDF-${version}.tar.gz";
    sha256 = "0gfjps7v93n0rrdndkhp22d93y892bf76pnzdhqbish0cigkkxph";
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
