{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, zlib
, xz
, bzip2
, zchunk
, zstd
, expat
, withRpm ? !stdenv.isDarwin
, rpm
, db
, withConda ? true
}:

stdenv.mkDerivation rec {
  version = "0.7.29";
  pname = "libsolv";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libsolv";
    rev = version;
    hash = "sha256-867sCGFvKib1As9BCiCi6LYVrLUK0pjtM5Bw9Yuu0D8=";
  };

  cmakeFlags = [
    "-DENABLE_COMPLEX_DEPS=true"
    (lib.cmakeBool "ENABLE_CONDA" withConda)
    "-DENABLE_LZMA_COMPRESSION=true"
    "-DENABLE_BZIP2_COMPRESSION=true"
    "-DENABLE_ZSTD_COMPRESSION=true"
    "-DENABLE_ZCHUNK_COMPRESSION=true"
    "-DWITH_SYSTEM_ZCHUNK=true"
  ] ++ lib.optionals withRpm [
    "-DENABLE_COMPS=true"
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
    homepage = "https://github.com/openSUSE/libsolv";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ copumpkin ];
  };
}
