{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gettext,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gnome-video-effects";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "166utGs/WoMvsuDZC0K/jGFgICylKsmt0Xr84ZLjyKg=";
  };

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
    homepage = "https://gitlab.gnome.org/GNOME/gnome-video-effects";
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
  };
}
