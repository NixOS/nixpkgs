{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.12";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "159givfh5jgli3cifxgssivkklfyfq6lzyjgrx8h4jx5ncdqyr5q";
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
