{ stdenv
, fetchurl
, autoreconfHook
, fetchpatch
, dconf
, evolution-data-server
, gdm
, gettext
, glib
, gnome-desktop
, gnome-menus
, gnome3
, gtk
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
  version = "3.30.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "12q0l7wy6hzl46i7xpvv82ka3bn14z0jg6fhv5xhnk7j9mkbmgqw";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/36468
    # https://gitlab.gnome.org/GNOME/gnome-panel/issues/8
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-panel/commit/77be9c3507bd1b5d70d97649b85ec9f47f6c359c.patch;
      sha256 = "00b1ihnc6hp2g6x1v1njbc6mhsk44izl2wigviibmka2znfk03nv";
    })
  ];

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
    gtk
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
    homepage = https://wiki.gnome.org/Projects/GnomePanel;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
