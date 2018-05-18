{ stdenv, fetchurl, gfortran, perl }:

let
  version = "3.0.1";

in stdenv.mkDerivation {
  name = "libxc-${version}";
  src = fetchurl {
    url = "http://www.tddft.org/programs/octopus/down.php?file=libxc/${version}/libxc-${version}.tar.gz";
    sha256 = "1xyac89yx03vm86rvk07ps1d39xss3amw46a1k53mv30mgr94rl3";
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
