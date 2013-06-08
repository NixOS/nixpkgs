{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python }:

stdenv.mkDerivation rec {
  name = "gobject-introspection-1.34.0";

  buildInputs = [ flex bison glib pkgconfig python ];
  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = "--disable-tests";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/1.34/${name}.tar.xz";
    sha256 = "80e211ea95404fc7c5fa3b04ba69ee0b29af70847af315155ab06b8cff832c85";
  };

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    homepage = http://live.gnome.org/GObjectIntrospection;
  };
}
