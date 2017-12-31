{ stdenv, fetchurl, gfortran, perl }:

let
  version = "2.2.3";
in stdenv.mkDerivation {
  name = "libxc-${version}";
  src = fetchurl {
    url = "http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-${version}.tar.gz";
    sha256 = "1rv8vsf7zzw0g7j93rqcipzhk2pj1iq71bpkwf7zxivmgavh0arg";
  };

  buildInputs = [ gfortran ];
  nativeBuildInputs = [ perl ];

  preConfigure = ''
    patchShebangs ./
  '';

  configureFlags = [ "--enable-shared" ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library of exchange-correlation functionals for density-functional theory";
    homepage = http://octopus-code.org/wiki/Libxc;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ markuskowa ];
  };
}
