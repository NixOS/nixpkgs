{ lib, stdenv, fetchFromGitHub, cmake, bzip2, libtomcrypt, zlib }:

stdenv.mkDerivation rec {
  pname = "StormLib";
  version = "9.23";

  src = fetchFromGitHub {
    owner = "ladislav-zezula";
    repo = "StormLib";
    rev = "v${version}";
    sha256 = "sha256-8JDMqZ5BWslH4+Mfo5lnWTmD2QDaColwBOLzcuGZciY=";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DWITH_LIBTOMCRYPT=ON"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ bzip2 libtomcrypt zlib ];

  meta = with lib; {
    homepage = "https://github.com/ladislav-zezula/StormLib";
    license = licenses.mit;
    description = "An open-source project that can work with Blizzard MPQ archives";
    platforms = platforms.all;
    maintainers = with maintainers; [ aanderse karolchmist ];
  };
}
