{ lib
, stdenv
, fetchFromRepoOrCz
, cmake
, libGL
, libpng
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
  pname = "glpng";
  version = "1.46";

  src = fetchFromRepoOrCz {
    repo = "glpng";
    rev = "v${version}";
    hash = "sha256-C7EHaBN0PE/HJB6zcIaYU63+o7/MEz4WU1xr/kIOanM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libGL
    libpng
    zlib
  ];

  meta = with lib; {
    homepage = "https://repo.or.cz/glpng.git/blob_plain/HEAD:/glpng.htm";
    description = "PNG loader library for OpenGL";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
