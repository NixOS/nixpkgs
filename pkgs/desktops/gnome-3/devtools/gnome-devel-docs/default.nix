{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "gnome-devel-docs";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-devel-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hzbmz6ji2g94353az5i9iqaq66jn09lhac9af9b85qykx4zfj3z";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-devel-docs"; attrPath = "gnome3.gnome-devel-docs"; };
  };

  buildInputs = [ intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/GNOME/gnome-devel-docs";
    description = "Developer documentation for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.fdl12;
    platforms = platforms.linux;
  };
}
