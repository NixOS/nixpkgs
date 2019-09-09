{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango, vala
, libxml2, perl, gettext, gnome3, gobject-introspection, dbus, xvfb_run, shared-mime-info }:

stdenv.mkDerivation rec {
  pname = "gtksourceview";
  version = "4.2.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0xgnjj7jd56wbl99s76sa1vjq9bkz4mdsxwgwlcphg689liyncf4";
  };

  propagatedBuildInputs = [
    # Required by gtksourceview-4.0.pc
    gtk3
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gettext perl gobject-introspection vala ];

  checkInputs = [ xvfb_run dbus ];

  buildInputs = [ atk cairo glib pango libxml2 ];

  patches = [ ./4.x-nix_share_path.patch ];

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
      attrPath = "gtksourceview4";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GtkSourceView;
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
  };
}
