{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python }:

let
  baseName = "gobject-introspection";
  v = "0.10.8";
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
    sha256 = "5b1387ff37f03db880a2b1cbd6c6b6dfb923a29468d4d8367c458abf7704c61e";
  };

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    homepage = http://live.gnome.org/GObjectIntrospection;
  };
}
