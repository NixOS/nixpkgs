{ stdenv, fetchurl, buildPythonPackage, pkgconfig, glib, gobjectIntrospection, pycairo, cairo, which, ncurses}:

buildPythonPackage rec {
  major = "3.26";
  minor = "1";
  version = "${major}.${minor}";
  format = "other";
  pname = "pygobject";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/${major}/${name}.tar.xz";
    sha256 = "1afi0jdjd9sanrzjwhv7z1k7qxlb91fqa6yqc2dbpjkhkjdpnmzm";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gobjectIntrospection ]
                 ++ stdenv.lib.optionals stdenv.isDarwin [ which ncurses ];
  propagatedBuildInputs = [ pycairo cairo ];

  meta = {
    homepage = https://pygobject.readthedocs.io/;
    description = "Python bindings for Glib";
    platforms = stdenv.lib.platforms.unix;
  };
}
