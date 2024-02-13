{ lib
, stdenv
, fetchurl
, vala
, gettext
, pkg-config
, gtk3
, glib
, gpgme
, json-glib
, wrapGAppsHook
, libpeas
, bash
, gobject-introspection
, gtksourceview4
, gsettings-desktop-schemas
, gnome
, gspell
, shared-mime-info
, libgee
, libgit2-glib
, libhandy
, libsecret
, libxml2
, meson
, ninja
, python3
, libdazzle
}:

stdenv.mkDerivation rec {
  pname = "gitg";
  version = "44";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-NCoxaE2rlnHNNBvT485mWtzuBGDCoIHdxJPNvAMTJTA=";
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
    glib
    gpgme
    gsettings-desktop-schemas
    gtk3
    gtksourceview4
    gspell
    json-glib
    libdazzle
    libgee
    libgit2-glib
    libhandy
    libpeas
    libsecret
    libxml2
  ];

  doCheck = true;

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
    mainProgram = "gitg";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
