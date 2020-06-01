{ stdenv, fetchurl, pkgconfig, glib, zlib, gnupg, gpgme, libidn2, libunistring, gobject-introspection
, vala }:

stdenv.mkDerivation rec {
  version = "3.2.7";
  pname = "gmime";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/3.2/${pname}-${version}.tar.xz";
    sha256 = "0i3xfc84qn1z99i70q68kbnp9rmgqrnprqb418ba52s6g9j9dsia";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ vala gobject-introspection zlib gpgme libidn2 libunistring ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib ];
  configureFlags = [
    "--enable-introspection=yes"
    "--enable-vala=yes"
  ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm
  '';

  checkInputs = [ gnupg ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/jstedfast/gmime/";
    description = "A C/C++ library for creating, editing and parsing MIME messages and structures";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
