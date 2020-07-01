{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "loki";
  version = "0.1.7";

  src = fetchurl {
    url = "mirror://sourceforge/loki-lib/Loki/Loki%20${version}/loki-${version}.tar.gz";
    sha256 = "1xhwna961fl4298ac5cc629x5030zlw31vx4h8zws290amw5860g";
  };

  buildPhase = ''
    substituteInPlace Makefile.common --replace /usr $out
    make build-shared
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A C++ library of designs, containing flexible implementations of common design patterns and idioms";
    homepage = "http://loki-lib.sourceforge.net";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
