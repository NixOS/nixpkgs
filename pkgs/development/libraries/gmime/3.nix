{ stdenv, fetchurl, pkgconfig, glib, zlib, gnupg, gpgme, libidn2, libunistring, gobject-introspection }:

stdenv.mkDerivation rec {
  version = "3.2.5";
  pname = "gmime";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/3.2/${pname}-${version}.tar.xz";
    sha256 = "0ndsg1z1kq4w4caascydvialpyn4rfbjdn7xclzbzhw53x85cxgv";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ gobject-introspection zlib gpgme libidn2 libunistring ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib ];
  configureFlags = [ "--enable-introspection=yes" ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm
  '';

  checkInputs = [ gnupg ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/jstedfast/gmime/;
    description = "A C/C++ library for creating, editing and parsing MIME messages and structures";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
