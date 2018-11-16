{ stdenv, fetchurl, pkgconfig, glib, zlib, gnupg, libgpgerror, gobjectIntrospection }:

stdenv.mkDerivation rec {
  version = "2.6.23";
  name = "gmime-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.6/${name}.tar.xz";
    sha256 = "0slzlzcr3h8jikpz5a5amqd0csqh2m40gdk910ws2hnaf5m6hjbi";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];
  propagatedBuildInputs = [ glib zlib libgpgerror ];
  configureFlags = [ "--enable-introspection=yes" ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm \
      --replace /bin/mkdir mkdir

    substituteInPlace tests/test-pkcs7.c \
      --replace /bin/mkdir mkdir
  '';

  checkInputs = [ gnupg ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/jstedfast/gmime/;
    description = "A C/C++ library for creating, editing and parsing MIME messages and structures";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chaoflow ];
    platforms = platforms.unix;
  };
}
