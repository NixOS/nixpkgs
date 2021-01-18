{ lib, stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "gnome-getting-started-docs";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-getting-started-docs/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0ficf4i4njqrx3dn5rdkvpvcys5mwfma4zkgfmfkq964jxpwzqvw";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-getting-started-docs"; attrPath = "gnome3.gnome-getting-started-docs"; };
  };

  buildInputs = [ intltool itstool libxml2 ];

  meta = with lib; {
    homepage = "https://live.gnome.org/DocumentationProject";
    description = "Help a new user get started in GNOME";
    maintainers = teams.gnome.members;
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
  };
}
