{ stdenv
, fetchurl
, autoreconfHook
, dconf
, evolution-data-server
, gdm
, gettext
, glib
, gnome-desktop
, gnome-menus
, gnome3
, gtk3
, itstool
, libgweather
, libsoup
, libwnck3
, libxml2
, pkgconfig
, polkit
, systemd
, wrapGAppsHook }:

let
  pname = "gnome-panel";
  version = "3.36.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1lxba8syy9gb50zxdk13gr1f62dfphwbb7njg6p26x9rvlkbf88y";
  };

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
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    dconf
    evolution-data-server
    gdm
    glib
    gnome-desktop
    gnome-menus
    gtk3
    libgweather
    libsoup
    libwnck3
    polkit
    systemd
  ];

  configureFlags = [
    "--enable-eds"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Component of Gnome Flashback that provides panels and default applets for the desktop";
    homepage = "https://wiki.gnome.org/Projects/GnomePanel";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
