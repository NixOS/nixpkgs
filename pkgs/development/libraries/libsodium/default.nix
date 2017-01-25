{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.11";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "0rf7z6bgpnf8lyz8sph4h43fbb28pmj4dgybf0hsxxj97kdljid1";
  };

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A modern and easy-to-use crypto library";
    homepage = http://doc.libsodium.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ raskin viric wkennington ];
    platforms = platforms.all;
  };
}
