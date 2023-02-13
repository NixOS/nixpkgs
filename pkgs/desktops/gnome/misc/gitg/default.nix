{ lib
, stdenv
, fetchurl
, fetchpatch
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
, gtksourceview4
, gsettings-desktop-schemas
, adwaita-icon-theme
, gnome
, gspell
, shared-mime-info
, libgee
, libgit2-glib
, libsecret
, libxml2
, meson
, ninja
, python3
, libdazzle
}:

stdenv.mkDerivation rec {
  pname = "gitg";
  version = "41";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "f7Ybn7EPuqVI0j1wZbq9cq1j5iHeVYQMBlzm45hsRik=";
  };

  patches = [
    # Fix build with meson 0.61
    # data/meson.build:8:5: ERROR: Function does not take positional arguments.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gitg/-/commit/1978973b12848741b08695ec2020bac98584d636.patch";
      sha256 = "sha256-RzaGPGGiKMgjy0waFqt48rV2yWBGZgC3kHehhVhxktk=";
    })
  ];

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
    gtksourceview4
    gspell
    json-glib
    libdazzle
    libgee
    libgit2-glib
    libpeas
    libsecret
    libxml2
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
