{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libsodium";
  version = "1.0.18";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${pname}-${version}.tar.gz";
    sha256 = "1h9ncvj23qbbni958knzsli8dvybcswcjbx0qjjgi922nf848l3g";
  };

  outputs = [ "out" "dev" ];
  separateDebugInfo = stdenv.isLinux;

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A modern and easy-to-use crypto library";
    homepage = http://doc.libsodium.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
  };
}
