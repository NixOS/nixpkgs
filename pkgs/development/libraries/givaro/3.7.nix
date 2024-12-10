{
  lib,
  stdenv,
  fetchurl,
  automake,
  autoconf,
  libtool,
  autoreconfHook,
  gmpxx,
}:
stdenv.mkDerivation rec {
  pname = "givaro";
  version = "3.7.2";
  src = fetchurl {
    url = "https://forge.imag.fr/frs/download.php/370/givaro-${version}.tar.gz";
    sha256 = "0lf5cnbyr27fw7klc3zabkb1979dn67jmrjz6pa3jzw2ng74x9b3";
  };
  nativeBuildInputs = [
    autoreconfHook
    autoconf
    automake
  ];
  buildInputs = [
    libtool
    gmpxx
  ];
  meta = {
    description = "A C++ library for arithmetic and algebraic computations";
    license = lib.licenses.cecill-b;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
