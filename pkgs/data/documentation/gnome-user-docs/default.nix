{ stdenv
, fetchurl
, gettext
, gnome3
, itstool
, libxml2
, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "gnome-user-docs";
  version = "3.34.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1r5ilrvnrmclvzxv3abzd9x2m0akcfv74sby8jzq8m7nn87yal7w";
  };

  nativeBuildInputs = [
    gettext
    itstool
    libxml2
    yelp-tools
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "User and system administration help for the GNOME desktop";
    homepage = "https://help.gnome.org/users/gnome-help/";
    license = licenses.cc-by-30;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
