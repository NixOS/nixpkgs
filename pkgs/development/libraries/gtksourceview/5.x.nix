{ lib
, stdenv
, fetchurl
, fetchpatch2
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
  version = "5.6.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "HxRsFW8TWmBJnZeeNXfJm24VoRFEV2er5iGbs0xUXHc=";
  };

  patches = [
    # By default, the library loads syntaxes from XDG_DATA_DIRS and user directory
    # but not from its own datadr (it assumes it will be in XDG_DATA_DIRS).
    # Since this is not generally true with Nix, let’s add $out/share unconditionally.
    ./4.x-nix_share_path.patch

    # Add Nix syntax highlighting.
    # https://gitlab.gnome.org/GNOME/gtksourceview/-/merge_requests/303
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gtksourceview/-/commit/2cc7fd079f9fc8b593c727c68a2c783c82299562.patch";
      sha256 = "bTYWjEDpdbnUxcYNKl2YtSLfYlMfcbQSSYQjhixOGS8=";
    })
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

  nativeCheckInputs = [
    xvfb-run
    dbus
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    # https://gitlab.gnome.org/GNOME/gtksourceview/-/merge_requests/295
    # build: drop unnecessary vapigen check
    substituteInPlace meson.build \
      --replace "if generate_vapi" "if false"
  '';

  doCheck = stdenv.isLinux;

  checkPhase = ''
    runHook preCheck

    env \
      XDG_DATA_DIRS="$XDG_DATA_DIRS:${shared-mime-info}/share" \
      GTK_A11Y=none \
      xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
        --config-file=${dbus}/share/dbus-1/session.conf \
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
