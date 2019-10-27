{ stdenv, fetchurl, gnome3 }:

stdenv.mkDerivation rec {
  pname = "mobile-broadband-provider-info";
  version = "20190116";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "16y5lc7pfdvai9c8xwb825zc3v46039gghbip13fqslf5gw11fic";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Mobile broadband service provider database";
    homepage = https://wiki.gnome.org/Projects/NetworkManager/MobileBroadband/ServiceProviders;
    license = licenses.publicDomain;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
