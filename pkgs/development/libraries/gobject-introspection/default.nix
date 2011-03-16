{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python }:

let
  baseName = "gobject-introspection";
  v = "0.10.2";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${v}";

  buildInputs = [ flex bison glib pkgconfig python ];
  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = "--disable-tests";

  src = fetchurl {
    url = "mirror://gnome/sources/${baseName}/0.10/${name}.tar.bz2";
    sha256 = "18di6v39hibb6j39vs0a5icaafihfryh8250kz7x1q1313pvm62v";
  };

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    homepage = http://live.gnome.org/GObjectIntrospection;
  };
}
