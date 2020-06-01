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
  version = "3.36.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0n4rbrq5zww6gjjmicyw5hlvzi8azc6m4sisak15snkp6v4f93qr";
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
