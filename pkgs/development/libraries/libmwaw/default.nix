{ lib, stdenv, fetchurl, boost, pkg-config, cppunit, zlib, libwpg, libwpd, librevenge }:

stdenv.mkDerivation rec {
  pname = "libmwaw";
<<<<<<< HEAD
  version = "0.3.22";

  src = fetchurl {
    url = "mirror://sourceforge/libmwaw/libmwaw/libmwaw-${version}/libmwaw-${version}.tar.xz";
    sha256 = "sha256-oaOf/Oo/8qenquDCOHfd9JGLVUv4Kw3l186Of2HqjjI=";
=======
  version = "0.3.21";

  src = fetchurl {
    url = "mirror://sourceforge/libmwaw/libmwaw/libmwaw-${version}/libmwaw-${version}.tar.xz";
    sha256 = "sha256-6HUBI6eNYblDzveLdzbIp/ILsKZJqhEkAhJPunlPwhw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    cppunit
    zlib
    libwpg
    libwpd
    librevenge
  ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Import library for some old mac text documents";
    license = licenses.mpl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
