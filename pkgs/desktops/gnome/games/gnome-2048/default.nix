{ lib
, stdenv
, fetchurl
, fetchpatch
, wrapGAppsHook3
, meson
, vala
, pkg-config
, ninja
, itstool
, clutter-gtk
, libgee
, libgnome-games-support
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

  patches = [
    # Fix build with meson 0.61
    # https://gitlab.gnome.org/GNOME/gnome-2048/-/merge_requests/21
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-2048/-/commit/194e22699f7166a016cd39ba26dd719aeecfc868.patch";
      sha256 = "Qpn/OJJwblRm5Pi453aU2HwbrNjsf+ftmSnns/5qZ9E=";
    })
  ];

  nativeBuildInputs = [
    itstool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    clutter-gtk
    libgee
    libgnome-games-support
    gtk3
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-2048";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-2048";
    description = "Obtain the 2048 tile";
    mainProgram = "gnome-2048";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
