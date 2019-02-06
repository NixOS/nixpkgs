{ stdenv, fetchurl }:

let
  version = "20190116";
  pname = "mobile-broadband-provider-info";
  name = "${pname}-${version}";
in
stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${name}.tar.xz";
    sha256 = "16y5lc7pfdvai9c8xwb825zc3v46039gghbip13fqslf5gw11fic";
  };

  meta = {
    description = "Mobile broadband service provider database";
    homepage = http://live.gnome.org/NetworkManager/MobileBroadband/ServiceProviders;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = [ ];
  };
}
