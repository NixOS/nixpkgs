{ lib, stdenv, fetchurl, pkg-config, file, intltool, glib, gtk3, libxklavier, wrapGAppsHook, gnome }:

stdenv.mkDerivation rec {
  pname = "libgnomekbd";
  version = "3.26.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0y962ykn3rr9gylj0pwpww7bi20lmhvsw6qvxs5bisbn2mih5jpp";
  };

  nativeBuildInputs = [
    file
    intltool
    pkg-config
    wrapGAppsHook
  ];

  # Requires in libgnomekbd.pc
  propagatedBuildInputs = [
    gtk3
    libxklavier
    glib
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Keyboard management library";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
