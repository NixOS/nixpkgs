{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, atk
, cairo
, glib
, gtk3
, pango
, fribidi
, vala
, libxml2
, perl
, gettext
, gnome
, gobject-introspection
, dbus
, xvfb-run
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "gtksourceview";
  version = "4.8.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "wwAZUGMgyiR02DTM7R4iF+pTPgDrKj9Ot4eQB5QOxoI=";
  };

  patches = [
    # By default, the library loads syntaxes from XDG_DATA_DIRS and user directory
    # but not from its own datadr (it assumes it will be in XDG_DATA_DIRS).
    # Since this is not generally true with Nix, let’s add $out/share unconditionally.
    ./4.x-nix_share_path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    perl
    gobject-introspection
    vala
  ];

  buildInputs = [
    atk
    cairo
    glib
    pango
    fribidi
    libxml2
  ];

  propagatedBuildInputs = [
    # Required by gtksourceview-4.0.pc
    gtk3
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  checkInputs = [
    xvfb-run
    dbus
  ];

  doCheck = stdenv.isLinux;

  checkPhase = ''
    runHook preCheck

    XDG_DATA_DIRS="$XDG_DATA_DIRS:${shared-mime-info}/share" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --no-rebuild --print-errorlogs

    runHook postCheck
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gtksourceview";
      attrPath = "gtksourceview4";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "Source code editing widget for GTK";
    homepage = "https://wiki.gnome.org/Projects/GtkSourceView";
    platforms = platforms.unix;
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
  };
}
