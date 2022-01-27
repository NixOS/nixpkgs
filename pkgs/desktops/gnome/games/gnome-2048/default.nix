{ lib
, stdenv
, fetchurl
, wrapGAppsHook
, meson
, vala
, pkg-config
, ninja
, itstool
, clutter-gtk
, libgee
, gnome
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "gnome-twenty-forty-eight";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-2048/${lib.versions.majorMinor version}/gnome-2048-${version}.tar.xz";
    sha256 = "0s5fg4z5in1h39fcr69j1qc5ynmg7a8mfprk3mc3c0csq3snfwz2";
  };

  nativeBuildInputs = [
    itstool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    libgee
    gnome.libgnome-games-support
    gtk3
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-2048";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/2048";
    description = "Obtain the 2048 tile";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
