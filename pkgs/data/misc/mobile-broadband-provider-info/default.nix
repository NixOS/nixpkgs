{ stdenv, fetchurl }:

let
  version = "20110511";
  pname = "mobile-broadband-provider-info";
  name = "${pname}-${version}";
in
stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${name}.tar.bz2";
    sha256 = "0cny8bd6kdwvabnwdr00f4wp4xjbc8ynp0kcdg72c1q9186kdikj";
  };

  meta = {
    description = "Mobile broadband service provider database";
    homepage = http://live.gnome.org/NetworkManager/MobileBroadband/ServiceProviders;
    platforms = stdenv.lib.platforms.all;
    license = "CC-PD";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
