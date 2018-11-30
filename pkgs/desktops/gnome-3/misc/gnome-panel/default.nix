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
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1004cp9cxqpic9lsraqn5c1739acn4sn4ql3c1fja99hv22h1ziv";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/36468
    # https://gitlab.gnome.org/GNOME/gnome-panel/issues/6
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-panel/commit/be26e170a10c297949a6d9f3cbc70b6caaf04b56.patch;
      sha256 = "10gxl9fwbv5j0s1lz7gkz6wqpda5wfzs49r5khbk1h05lv0hk4l4";
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
