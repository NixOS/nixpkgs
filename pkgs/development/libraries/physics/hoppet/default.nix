{ lib, stdenv, fetchurl, gfortran, perl }:

stdenv.mkDerivation rec {
  pname = "hoppet";
  version = "1.2.0";

  src = fetchurl {
    url = "https://hoppet.hepforge.org/downloads/${pname}-${version}.tgz";
    sha256 = "0j7437rh4xxbfzmkjr22ry34xm266gijzj6mvrq193fcsfzipzdz";
  };

  nativeBuildInputs = [ perl gfortran  ];

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs .
  '';

  meta = with lib; {
    description = "Higher Order Perturbative Parton Evolution Toolkit";
    mainProgram = "hoppet-config";
    license     = licenses.gpl2;
    homepage    = "https://hoppet.hepforge.org";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
