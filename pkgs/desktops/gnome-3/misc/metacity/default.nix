{ stdenv
, fetchurl
, gettext
, glib
, gnome3
, gsettings-desktop-schemas
, gtk
, libcanberra-gtk3
, libgtop
, libstartup_notification
, libxml2
, pkgconfig
, substituteAll
, wrapGAppsHook
, zenity }:

let
  pname = "metacity";
  version = "3.30.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "12kr472gblx7jxh9rvnamy09bkg29ms2pgc0c3373piqmavi24qg";
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
    glib
    gsettings-desktop-schemas
    gtk
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
    homepage = https://wiki.gnome.org/Projects/Metacity;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
