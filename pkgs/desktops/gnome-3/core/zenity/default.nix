{ stdenv
, fetchurl
, pkgconfig
, libxml2
, gnome3
, gtk3
, yelp-tools
, gettext
, libX11
, itstool
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "zenity";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "15fdh8xfdhnwcynyh4byx3mrjxbyprqnwxzi7qn3g5wwaqryg1p7";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    yelp-tools
    itstool
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libX11
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "zenity";
      attrPath = "gnome3.zenity";
    };
  };

  meta = with stdenv.lib; {
    description = "Tool to display dialogs from the commandline and shell scripts";
    homepage = "https://wiki.gnome.org/Projects/Zenity";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
