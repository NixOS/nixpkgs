{ stdenv
, fetchurl
, gettext
, glib
, gnome3
, gsettings-desktop-schemas
, gtk3
, xorg
, libcanberra-gtk3
, libgtop
, libstartup_notification
, libxml2
, pkgconfig
, substituteAll
, wrapGAppsHook
, zenity
}:

stdenv.mkDerivation rec {
  pname = "metacity";
  version = "3.37.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "09m102lpy68730y8y7vjyaw3cavlbdbiyix6s0kgna23bbcz7ml0";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit zenity;
    })
  ];

  nativeBuildInputs = [
    gettext
    libxml2
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    xorg.libXres
    glib
    gsettings-desktop-schemas
    gtk3
    libcanberra-gtk3
    libgtop
    libstartup_notification
    zenity
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Window manager used in Gnome Flashback";
    homepage = "https://wiki.gnome.org/Projects/Metacity";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
