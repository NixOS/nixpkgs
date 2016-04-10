{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.10";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "1gn45g956lyz8l6iq187yc6l627vyivyp8qc5dkr6dnhdnlqddvi";
  };

  outputs = [ "dev" "out" ];

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
