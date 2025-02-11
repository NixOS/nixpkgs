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
  version = "3.8.0";
  src = fetchurl {
    url = "https://forge.imag.fr/frs/download.php/592/givaro-${version}.tar.gz";
    sha256 = "1822ksv8653a84hvcz0vxl3nk8dqz7d41ys8rplq0zjjmvb2i5yq";
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
    description = "C++ library for arithmetic and algebraic computations";
    license = lib.licenses.cecill-b;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
