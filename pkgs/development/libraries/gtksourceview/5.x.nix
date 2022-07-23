{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, glib
, pcre2
, gtk4
, pango
, fribidi
, vala
, gi-docgen
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
  version = "5.5.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "V8kgm1ypfVKq7JbwZfenXQj/k6/i5+b0ezVbhVnH94Q=";
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
    gi-docgen
  ];

  buildInputs = [
    glib
    pcre2
    pango
    fribidi
    libxml2
  ];

  propagatedBuildInputs = [
    # Required by gtksourceview-5.0.pc
    gtk4
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  checkInputs = [
    xvfb-run
    dbus
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
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

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gtksourceview";
      attrPath = "gtksourceview5";
      versionPolicy = "odd-unstable";
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
