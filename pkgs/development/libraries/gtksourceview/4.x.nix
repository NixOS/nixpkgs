{ lib, stdenv, fetchurl, pkg-config, atk, cairo, glib, gtk3, pango, fribidi, vala
, libxml2, perl, gettext, gnome3, gobject-introspection, dbus, xvfb_run, shared-mime-info
, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "gtksourceview";
  version = "4.8.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0WPXG1/K+8Wx7sbdhB7b283dOnURzV/c/9hri7/mmsE=";
  };

  propagatedBuildInputs = [
    # Required by gtksourceview-4.0.pc
    gtk3
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkg-config gettext perl gobject-introspection vala ];

  checkInputs = [ xvfb_run dbus ];

  buildInputs = [ atk cairo glib pango fribidi libxml2 ];

  patches = [ ./4.x-nix_share_path.patch ];

  enableParallelBuilding = true;

  doCheck = stdenv.isLinux;
  checkPhase = ''
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${shared-mime-info}/share" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --no-rebuild --print-errorlogs
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtksourceview";
      attrPath = "gtksourceview4";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GtkSourceView";
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl21;
    maintainers = teams.gnome.members;
  };
}
