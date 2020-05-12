{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, python3
, wrapGAppsHook
, gettext
, gnome3
, glib
, gtk3
, libpeas
, gnome-online-accounts
, gsettings-desktop-schemas
, evolution-data-server
, libxml2
, libsoup
, libical
, librest
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gnome-todo";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "08ygqbib72jlf9y0a16k54zz51sncpq2wa18wp81v46q8301ymy7";
  };

  patches = [
    # fix build with libecal 2.0
    (fetchpatch {
      name = "gnome-todo-eds-libecal-2.0.patch";
      url = "https://src.fedoraproject.org/rpms/gnome-todo/raw/bed44b8530f3c79589982e03b430b3a125e9bceb/f/gnome-todo-eds-libecal-2.0.patch";
      sha256 = "1ghrz973skal36j90wm2z13m3panw983r6y0k7z9gpj5lxgz92mq";
    })
  ];
  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libpeas
    gnome-online-accounts
    gsettings-desktop-schemas
    gnome3.adwaita-icon-theme
    # Plug-ins
    evolution-data-server
    libxml2
    libsoup
    libical
    librest
    json-glib
  ];

  # Fix parallel building: missing dependency from src/gtd-application.c
  # Probably remove for 3.30+ https://gitlab.gnome.org/GNOME/gnome-todo/issues/170
  preBuild = "ninja src/gtd-vcs-identifier.h";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Personal task manager for GNOME";
    homepage = "https://wiki.gnome.org/Apps/Todo";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
