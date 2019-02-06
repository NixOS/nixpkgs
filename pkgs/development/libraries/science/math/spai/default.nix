{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "spai";
  version = "3.0-p1";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/externalpackages/spai-${version}.tar.gz";
    sha256 = "13nadflrkanmw9v86z12kwwx63wys4k8s6iyaamx6apl8frxb708";
  };

  configurePhase = ''
    substituteInPlace lib/Makefile \
      --replace "include Makefile.in" ""
  '';

  buildPhase = ''
    make -C lib
  '';

  installPhase = ''
    mkdir -p $out/include
    cp lib/*.h $out/include
    mkdir -p $out/lib
    cp lib/libspai.a $out/lib
  '';

  meta = {
    description = "Sparse approximate inverse preconditioner";
    homepage = https://bitbucket.org/petsc/pkg-spai;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ jamtrott ];
  };
}
