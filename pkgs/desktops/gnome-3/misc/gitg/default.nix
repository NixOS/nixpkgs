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
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1wzsv7bh0a2w70f938hkpzbb9xkyrp3bil65c0q3yf2v72nbbn81";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gitg/issues/213
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gitg/merge_requests/83.patch";
      sha256 = "1f7wx1d3k5pnp8zbrqssip57b9jxn3hc7a83psm7fny970qmd18z";
    })
  ];

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
