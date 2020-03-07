{ stdenv
, fetchFromGitHub
, pkgconfig
, meson
, ninja
, zstd
, curl
}:

stdenv.mkDerivation rec {
  pname = "zchunk";
  version = "1.1.5";

  outputs = [ "out" "lib" "dev" ];

  src = fetchFromGitHub {
    owner = "zchunk";
    repo = pname;
    rev = version;
    sha256 = "13sqjslk634mkklnmzdlzk9l9rc6g6migig5rln3irdnjrxvjf69";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    zstd
    curl
  ];

  meta = with stdenv.lib; {
    description = "File format designed for highly efficient deltas while maintaining good compression";
    homepage = "https://github.com/zchunk/zchunk";
    license = licenses.bsd2;
    maintainers = with maintainers; [];
    platforms = platforms.unix;
  };
}
