{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango, vala
, libxml2, perl, intltool, gettext, gnome3, gobject-introspection, dbus, xvfb_run, shared-mime-info }:

stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "3.24.11";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1zbpj283b5ycz767hqz5kdq02wzsga65pp4fykvhg8xj6x50f6v9";
  };

  propagatedBuildInputs = [
    # Required by gtksourceview-3.0.pc
    gtk3
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig intltool perl gobject-introspection vala ];

  checkInputs = [ xvfb_run dbus ];

  buildInputs = [ atk cairo glib pango libxml2 gettext ];

  preBuild = ''
    substituteInPlace gtksourceview/gtksourceview-utils.c --replace "@NIX_SHARE_PATH@" "$out/share"
  '';

  patches = [ ./3.x-nix_share_path.patch ];

  enableParallelBuilding = true;

  doCheck = stdenv.isLinux;
  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${shared-mime-info}/share" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtksourceview";
      attrPath = "gnome3.gtksourceview";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GtkSourceView;
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
  };
}
