{ stdenv, fetchurl, gfortran, perl }:

stdenv.mkDerivation rec {
  name = "hoppet-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "https://hoppet.hepforge.org/downloads/${name}.tgz";
    sha256 = "0j7437rh4xxbfzmkjr22ry34xm266gijzj6mvrq193fcsfzipzdz";
  };

  buildInputs = [ gfortran ];
  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "Higher Order Perturbative Parton Evolution Toolkit";
    license     = licenses.gpl2;
    homepage    = https://hoppet.hepforge.org;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
