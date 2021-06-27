{ lib, stdenv, fetchurl, pkg-config, libxml2, gtk3, gnome, intltool }:

stdenv.mkDerivation rec {
  pname = "gdl";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "00ldva6wg6s4wlxmisiqzyz8ihsprra7sninx2rlqk6frpq312w5";
  };

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ libxml2 gtk3 ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gdl";
    };
  };

  meta = with lib; {
    description = "Gnome docking library";
    homepage = "https://developer.gnome.org/gdl/";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
