{ stdenv, fetchFromGitHub, cmake, pkg-config, zlib, bzip2, xz, zstd, openssl }:

stdenv.mkDerivation rec {
  pname = "minizip";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "nmoinvaz";
    repo = pname;
    rev = version;
    sha256 = "15bbagngvm738prkzv7lfs64pn4pq7jkhwz571j0w0nb5nw9c01x";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DMZ_OPENSSL=ON"
  ];

  buildInputs = [ zlib bzip2 xz zstd openssl ];

  meta = with stdenv.lib; {
    description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
    homepage = "https://github.com/nmoinvaz/minizip";
    license = licenses.zlib;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
