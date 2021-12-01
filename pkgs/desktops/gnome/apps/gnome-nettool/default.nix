{ lib, stdenv, fetchurl, pkg-config, gnome, gtk3, wrapGAppsHook
, libgtop, intltool, itstool, libxml2, nmap, inetutils }:

stdenv.mkDerivation rec {
  pname = "gnome-nettool";
  version = "3.8.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1c9cvzvyqgfwa5zzyvp7118pkclji62fkbb33g4y9sp5kw6m397h";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3 wrapGAppsHook libgtop intltool itstool libxml2
    gnome.adwaita-icon-theme
  ];

  propagatedUserEnvPkgs = [ nmap inetutils ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-nettool";
    description = "A collection of networking tools";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
