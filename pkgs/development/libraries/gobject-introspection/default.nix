{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python }:

let
  baseName = "gobject-introspection";
  v = "1.33.4";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${v}";

  buildInputs = [ flex bison glib pkgconfig python ];
  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = "--disable-tests";

  src = fetchurl {
    url = "mirror://gnome/sources/${baseName}/1.33/${name}.tar.xz";
    sha256 = "f8daf7d1bc76bd19062408c6f31caca452596a184df9f3ddd74d595f52068959";
  };

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    homepage = http://live.gnome.org/GObjectIntrospection;
  };
}
