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
  version = "1.1.6";

  outputs = [ "out" "lib" "dev" ];

  src = fetchFromGitHub {
    owner = "zchunk";
    repo = pname;
    rev = version;
    sha256 = "1j05f26xppwbkxrm11895blm75i1a6p9q23x7wlkqw198mpnpbbv";
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
