{ lib, stdenv, fetchurl, pkg-config, atk, cairo, glib, gtk3, pango, vala
, libxml2, perl, intltool, gettext, gobject-introspection, dbus, xvfb-run, shared-mime-info }:

stdenv.mkDerivation rec {
  pname = "gtksourceview";
  version = "3.24.11";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1zbpj283b5ycz767hqz5kdq02wzsga65pp4fykvhg8xj6x50f6v9";
  };

  propagatedBuildInputs = [
    # Required by gtksourceview-3.0.pc
    gtk3
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config intltool perl gobject-introspection vala ];

  nativeCheckInputs = [ xvfb-run dbus ];

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
      --config-file=${dbus}/share/dbus-1/session.conf \
      make check
  '';

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GtkSourceView";
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl21;
    maintainers = teams.gnome.members;
  };
}
