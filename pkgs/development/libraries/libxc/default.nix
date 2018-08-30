{ stdenv, fetchurl, gfortran, perl }:

let
  version = "4.2.3";

in stdenv.mkDerivation {
  name = "libxc-${version}";
  src = fetchurl {
    url = "http://www.tddft.org/programs/octopus/down.php?file=libxc/${version}/libxc-${version}.tar.gz";
    sha256 = "0mj26jga0nj76blf2rp9cmgf0v0yhsp7xrg92zgih7fjlydrxr02";
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
