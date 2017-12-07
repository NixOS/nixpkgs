{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.13";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "1z93wfg4k5svg8yck6cgdr6ysj91kbpn03nyzwxanncy3b5sq4ww";
  };

  outputs = [ "out" "dev" ];
  separateDebugInfo = stdenv.isLinux;

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
