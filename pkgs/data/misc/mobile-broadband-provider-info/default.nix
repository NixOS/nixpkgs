{ stdenv, fetchurl }:

let
  version = "20151214";
  pname = "mobile-broadband-provider-info";
  name = "${pname}-${version}";
in
stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${name}.tar.xz";
    sha256 = "1905nab1h8p4hx0m1w0rn4mkg9209x680dcr4l77bngy21pmvr4a";
  };

  meta = {
    description = "Mobile broadband service provider database";
    homepage = http://live.gnome.org/NetworkManager/MobileBroadband/ServiceProviders;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
