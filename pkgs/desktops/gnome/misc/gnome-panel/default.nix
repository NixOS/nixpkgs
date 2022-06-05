{ stdenv
, lib
, fetchurl
, fetchpatch
, autoreconfHook
, dconf
, evolution-data-server
, gdm
, geocode-glib
, gettext
, glib
, gnome-desktop
, gnome-menus
, gnome
, gtk3
, itstool
, libgweather
, libsoup
, libwnck
, libxml2
, pkg-config
, polkit
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-panel";
  version = "3.44.0";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-mWVfddAxh2wTDtI8TaIsCZ57zEBIsCVaPDo7vHh7Mao=";
  };

  patches = [
    # Load modules from path in `NIX_GNOME_PANEL_MODULESDIR` environment variable
    # instead of gnome-panel’s libdir so that the NixOS module can make gnome-panel
    # load modules from other packages as well.
    ./modulesdir-env-var.patch

    # Add missing geocode-glib-1.0 dependency
    # https://gitlab.gnome.org/GNOME/gnome-panel/-/merge_requests/49
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-panel/-/commit/f58a43ec4649a25f1a762b36e1401b81cd2b214b.patch";
      sha256 = "sha256-DFqaNUjkLh4xd81qgQpl+568eUZeWyF8LxdZoTgMfCQ=";
    })
  ];

  # make .desktop Exec absolute
  postPatch = ''
    patch -p0 <<END_PATCH
    +++ gnome-panel/gnome-panel.desktop.in
    @@ -7 +7 @@
    -Exec=gnome-panel
    +Exec=$out/bin/gnome-panel
    END_PATCH
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome-menus}/share"
      --prefix XDG_CONFIG_DIRS : "${gnome-menus}/etc/xdg"
    )
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    itstool
    libxml2
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    dconf
    evolution-data-server
    gdm
    geocode-glib
    glib
    gnome-desktop
    gnome-menus
    gtk3
    libgweather
    libsoup
    libwnck
    polkit
    systemd
  ];

  configureFlags = [
    "--enable-eds"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Component of Gnome Flashback that provides panels and default applets for the desktop";
    homepage = "https://wiki.gnome.org/Projects/GnomePanel";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
