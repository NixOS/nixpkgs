{ stdenv
, fetchurl
, fetchpatch
, vala
, gettext
, pkgconfig
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
, gnome3
, gtkspell3
, shared-mime-info
, libgee
, libgit2-glib
, libsecret
, meson
, ninja
, python3
, hicolor-icon-theme
, libdazzle
}:

stdenv.mkDerivation rec {
  pname = "gitg";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0npg4kqpwl992fgjd2cn3fh84aiwpdp9kd8z7rw2xaj2iazsm914";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py

    substituteInPlace tests/libgitg/test-commit.vala --replace "/bin/bash" "${bash}/bin/bash"
  '';

  doCheck = true;

  enableParallelBuilding = true;

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

  nativeBuildInputs = [
    gobject-introspection
    hicolor-icon-theme
    gettext
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gitg;
    description = "GNOME GUI client to view git repositories";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
