{ lib, stdenv, fetchFromGitHub, cmake, ninja, pkg-config
, zlib, xz, bzip2, zchunk, zstd
, expat
, withRpm ? !stdenv.isDarwin, rpm
, db
}:

stdenv.mkDerivation rec {
  version  = "0.7.23";
  pname = "libsolv";

  src = fetchFromGitHub {
    owner  = "openSUSE";
    repo   = "libsolv";
    rev    = version;
    sha256 = "sha256-i1g4arr8rII9SzdyITD6xS9CAVN6zP73gFwnZdkc5os=";
  };

  cmakeFlags = [
    "-DENABLE_COMPLEX_DEPS=true"
    "-DENABLE_LZMA_COMPRESSION=true"
    "-DENABLE_BZIP2_COMPRESSION=true"
    "-DENABLE_ZSTD_COMPRESSION=true"
    "-DENABLE_ZCHUNK_COMPRESSION=true"
    "-DWITH_SYSTEM_ZCHUNK=true"
  ] ++ lib.optionals withRpm [
    "-DENABLE_PUBKEY=true"
    "-DENABLE_RPMDB=true"
    "-DENABLE_RPMDB_BYRPMHEADER=true"
    "-DENABLE_RPMMD=true"
  ];

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [ zlib xz bzip2 zchunk zstd expat db ]
    ++ lib.optional withRpm rpm;

  meta = with lib; {
    description = "A free package dependency solver";
    homepage    = "https://github.com/openSUSE/libsolv";
    license     = licenses.bsd3;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ copumpkin ];
  };
}

