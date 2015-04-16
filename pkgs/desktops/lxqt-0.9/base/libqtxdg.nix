{ stdenv, fetchgit
, cmake
, file # libmagic.so
, qt54
, pkgconfig
}:

stdenv.mkDerivation rec {
  basename = "libqtxdg";
  version = "1.2.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "da936792f2376327db2c287348738ede394e7bcc";
    sha256 = "c676491c655d6af5d250a8855e0d7437ac53505f40640dd7e71bd1c08646b55f";
  };

  buildInputs = [ stdenv cmake qt54.base file pkgconfig ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library providing freedesktop.org specs implementations for Qt";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
