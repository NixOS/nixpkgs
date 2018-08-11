{ stdenv, fetchurl, pkgconfig, glib, zlib, gnupg, gpgme, libidn, gobjectIntrospection }:

stdenv.mkDerivation rec {
  version = "3.2.0";
  name = "gmime-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/3.2/${name}.tar.xz";
    sha256 = "1q6palbpf6lh6bvy9ly26q5apl5k0z0r4mvl6zzqh90rz4rn1v3m";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ gobjectIntrospection zlib gpgme libidn ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib ];
  configureFlags = [ "--enable-introspection=yes" ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm
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
