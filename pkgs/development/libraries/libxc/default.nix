{ stdenv, fetchurl, gfortran, perl }:

let
  version = "4.0.4";

in stdenv.mkDerivation {
  name = "libxc-${version}";
  src = fetchurl {
    url = "http://www.tddft.org/programs/octopus/down.php?file=libxc/${version}/libxc-${version}.tar.gz";
    sha256 = "1l43wcxn51ivy5wzdwfvvhim6vql82rw8fy5wk6s0p54xikhsgzn";
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
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markuskowa ];
  };
}
