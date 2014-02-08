{ stdenv, fetchurl, makeWrapper, python, intltool, pkgconfig
, gnome3, atk, pygobject3, dbus, libnotify, isocodes, gobjectIntrospection, wayland }:

stdenv.mkDerivation rec {
  name = "ibus-${version}";
  version = "1.5.5";

  src = fetchurl {
    url = "http://ibus.googlecode.com/files/${name}.tar.gz";
    sha256 = "1v4a9xv2k26g6ggk4282ynfvh68j2r5hg1cdpvnryfa8c2pkdaq2";
  };

  configureFlags = "--disable-gconf --enable-dconf --disable-memconf --enable-ui --enable-python-library";

  buildInputs = [
    makeWrapper python gnome3.glib wayland
    intltool pkgconfig gnome3.gtk2
    gnome3.gtk3 dbus gnome3.dconf gnome3.gconf
    libnotify isocodes gobjectIntrospection
  ];

  preBuild = "patchShebangs ./scripts";

  postInstall = ''
    for f in "$out"/bin/*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$out/share" \
                       --prefix PYTHONPATH : "$(toPythonPath ${pygobject3})" \
                       --prefix LD_LIBRARY_PATH : "${gnome3.gtk3}/lib:${atk}/lib:$out/lib" \
                       --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH:$out/lib/girepository-1.0" \
                       --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
    done
  '';

  meta = {
    homepage = https://code.google.com/p/ibus/;
    description = "Intelligent Input Bus for Linux / Unix OS";
    platforms = stdenv.lib.platforms.linux;
  };
}
