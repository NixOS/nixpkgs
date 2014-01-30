{ stdenv, fetchurl, makeWrapper, python, intltool, pkgconfig
, gnome3, dbus, libnotify, isocodes, gobjectIntrospection, wayland }:

stdenv.mkDerivation rec {
  name = "ibus-${version}";
  version = "1.5.5";

  src = fetchurl {
    url = "http://ibus.googlecode.com/files/${name}.tar.gz";
    sha256 = "1v4a9xv2k26g6ggk4282ynfvh68j2r5hg1cdpvnryfa8c2pkdaq2";
  };

  configureFlags = "--enable-dconf --disable-memconf --enable-ui --enable-python-library";

  buildInputs = [
    makeWrapper python gnome3.glib wayland
    intltool pkgconfig gnome3.gtk2
    gnome3.gtk3 dbus gnome3.dconf gnome3.gconf
    libnotify isocodes gobjectIntrospection
  ];

  preBuild = "patchShebangs ./scripts";

  postInstall  = ''
    for f in "$out"/bin/*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$out/share"
    done
  '';

  meta = {
    homepage = https://code.google.com/p/ibus/;
    description = "Intelligent Input Bus for Linux / Unix OS";
    platforms = stdenv.lib.platforms.linux;
  };
}
