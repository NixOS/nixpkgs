{ lib, stdenv
, cmake
, fetchurl
, perl
, zlib
, groff
, withBzip2 ? false
, bzip2
, withLZMA ? false
, xz
, withOpenssl ? false
, openssl
, withZstd ? false
, zstd
}:

stdenv.mkDerivation rec {
  pname = "libzip";
  version = "1.9.2";

  src = fetchurl {
    url = "https://libzip.org/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-/Wp/dF3j1pz1YD7cnLM9KJDwGY5BUlXQmHoM8Q2CTG8=";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ cmake perl groff ];
  propagatedBuildInputs = [ zlib ];
  buildInputs = lib.optionals withLZMA [ xz ]
    ++ lib.optionals withBzip2 [ bzip2 ]
    ++ lib.optionals withOpenssl [ openssl ]
    ++ lib.optionals withZstd [ zstd ];

  # Don't build the regression tests because they don't build with
  # pkgsStatic and are not executed anyway.
  cmakeFlags = [ "-DBUILD_REGRESS=0" ];

  preCheck = ''
    # regress/runtest is a generated file
    patchShebangs regress
  '';

  meta = with lib; {
    homepage = "https://libzip.org/";
    description = "A C library for reading, creating and modifying zip archives";
    license = licenses.bsd3;
    platforms = platforms.unix;
    changelog = "https://github.com/nih-at/libzip/blob/v${version}/NEWS.md";
  };
}
