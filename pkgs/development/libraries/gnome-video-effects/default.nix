{ lib, stdenv
, fetchurl
, pkg-config
, meson
, ninja
, gettext
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-video-effects";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1j6h98whgkcxrh30bwvnxvyqxrxchgpdgqhl0j71xz7x72dqxijd";
  };

  patches = [
    # Fix effectsdir in .pc file
    # https://gitlab.gnome.org/GNOME/gnome-video-effects/commit/955404195ada606819974dd63c48956f25611e14
    ./fix-pc-file.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A collection of GStreamer effects to be used in different GNOME Modules";
    homepage = "https://wiki.gnome.org/Projects/GnomeVideoEffects";
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
  };
}
