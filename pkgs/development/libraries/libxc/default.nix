{ stdenv, fetchurl, gfortran, perl }:

let
  version = "4.3.4";

in stdenv.mkDerivation {
  name = "libxc-${version}";
  src = fetchurl {
    url = "http://www.tddft.org/programs/octopus/down.php?file=libxc/${version}/libxc-${version}.tar.gz";
    sha256 = "0dw356dfwn2bwjdfwwi4h0kimm69aql2f4yk9f2kk4q7qpfkgvm8";
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
    homepage = https://octopus-code.org/wiki/Libxc;
    license = licenses.lgpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markuskowa ];
  };
}
