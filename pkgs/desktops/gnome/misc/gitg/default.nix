{ lib
, stdenv
, fetchurl
, vala
, gettext
, pkg-config
, gtk3
, glib
, json-glib
, wrapGAppsHook
, libpeas
, bash
, gobject-introspection
, libsoup
, gtksourceview
, gsettings-desktop-schemas
, adwaita-icon-theme
, gnome
, gtkspell3
, shared-mime-info
, libgee
, libgit2-glib
, libsecret
, meson
, ninja
, python3
, libdazzle
}:

stdenv.mkDerivation rec {
  pname = "gitg";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0npg4kqpwl992fgjd2cn3fh84aiwpdp9kd8z7rw2xaj2iazsm914";
  };

  nativeBuildInputs = [
    gobject-introspection
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    glib
    gsettings-desktop-schemas
    gtk3
    gtksourceview
    gtkspell3
    json-glib
    libdazzle
    libgee
    libgit2-glib
    libpeas
    libsecret
    libsoup
  ];

  doCheck = false; # FAIL: tests-gitg gtk_style_context_add_provider_for_screen: assertion 'GDK_IS_SCREEN (screen)' failed

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py

    substituteInPlace tests/libgitg/test-commit.vala --replace "/bin/bash" "${bash}/bin/bash"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Gitg";
    description = "GNOME GUI client to view git repositories";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
