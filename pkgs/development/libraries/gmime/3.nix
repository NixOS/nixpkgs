{ stdenv, fetchurl, pkgconfig, glib, zlib, gnupg, gpgme, libidn2, libunistring, gobject-introspection }:

stdenv.mkDerivation rec {
  version = "3.2.3";
  name = "gmime-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/3.2/${name}.tar.xz";
    sha256 = "04bk7rqs5slpvlvqf11i6s37s8b2xn6acls8smyl9asjnpp7a23a";
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
    maintainers = with maintainers; [ chaoflow ];
    platforms = platforms.unix;
  };
}
