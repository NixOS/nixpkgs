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
  version = "3.36.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0vnwya5g7fg0jhdrg9drxnx83lhk8qa2nvcrmd1sdfanlz4qfhjf";
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
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
