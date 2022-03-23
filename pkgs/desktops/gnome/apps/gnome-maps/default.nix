{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, gettext
, python3
, pkg-config
, gnome
, gtk3
, gobject-introspection
, gdk-pixbuf
, librest
, librsvg
, libgweather
, geoclue2
, wrapGAppsHook
, folks
, libchamplain
, libsoup
, gsettings-desktop-schemas
, webkitgtk
, gjs
, libgee
, libhandy
, geocode-glib
, evolution-data-server
, gnome-online-accounts
}:

stdenv.mkDerivation rec {
  pname = "gnome-maps";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-BUSG03dAc3BqdqmBQXl40VG+O3Ik1yN3W74xbvoked8=";
  };

  patches = [
    # Do not pin to GWeather 3.0, the used API did not change in 4.0.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-maps/-/commit/759d3087b70341b2c5f1af575ce44338d926690e.patch";
      sha256 = "Qp9Hta00TLf2lOb9+g9vnPoK17mP3eHpCG2i1ewaw+w=";
      revert = true;
    })
  ];

  doCheck = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    evolution-data-server
    folks
    gdk-pixbuf
    geoclue2
    geocode-glib
    gjs
    gnome-online-accounts
    gnome.adwaita-icon-theme
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    libchamplain
    libgee
    libgweather
    libhandy
    librest
    librsvg
    libsoup
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py

    # The .service file isn't wrapped with the correct environment
    # so misses GIR files when started. By re-pointing from the gjs
    # entry point to the wrapped binary we get back to a wrapped
    # binary.
    substituteInPlace "data/org.gnome.Maps.service.in" \
        --replace "Exec=@pkgdatadir@/@app-id@" \
                  "Exec=$out/bin/gnome-maps"
  '';

  preCheck = ''
    # “time.js” included by “timeTest” and “translationsTest” depends on “org.gnome.desktop.interface” schema.
    export XDG_DATA_DIRS="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:$XDG_DATA_DIRS"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Maps";
    description = "A map application for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
