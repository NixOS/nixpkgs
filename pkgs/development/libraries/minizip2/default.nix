{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, zlib, bzip2, xz, zstd, openssl }:

stdenv.mkDerivation rec {
  pname = "minizip";
  version = "2.10.6";

  src = fetchFromGitHub {
    owner = "nmoinvaz";
    repo = pname;
    rev = version;
    sha256 = "sha256-OAm4OZeQdP2Q/UKYI9bR7OV9RmLmYF/j2NpK5TPoE60=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DMZ_OPENSSL=ON"
  ];

  buildInputs = [ zlib bzip2 xz zstd openssl ];

  meta = with lib; {
    description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
    homepage = "https://github.com/nmoinvaz/minizip";
    license = licenses.zlib;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
