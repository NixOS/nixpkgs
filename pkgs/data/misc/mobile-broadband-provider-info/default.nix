{ stdenv, fetchurl }:

let
  version = "20120614";
  pname = "mobile-broadband-provider-info";
  name = "${pname}-${version}";
in
stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${name}.tar.xz";
    sha256 = "72507a732e0cd16cf27424bb094b1c7a03e2206c119ad124722a283e587755f1";
  };

  meta = {
    description = "Mobile broadband service provider database";
    homepage = http://live.gnome.org/NetworkManager/MobileBroadband/ServiceProviders;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
