{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, libgtop, intltool, itstool, libxml2, nmap, inetutils }:

stdenv.mkDerivation rec {
  name = "gnome-nettool-3.8.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nettool/3.8/${name}.tar.xz";
    sha256 = "1c9cvzvyqgfwa5zzyvp7118pkclji62fkbb33g4y9sp5kw6m397h";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook libgtop intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  propagatedUserEnvPkgs = [ nmap inetutils ];

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/gnome-network;
    description = "A collection of networking tools";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
