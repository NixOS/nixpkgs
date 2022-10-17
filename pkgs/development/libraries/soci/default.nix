{ cmake
, fetchFromGitHub
, fetchpatch
, sqlite
, postgresql
, boost
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "soci";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "SOCI";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NE0ApbX8HG2VAQ9cg9+kX3kJQ4PR1XvWL9BlT8NphmE=";
  };

  patches = [
    (fetchpatch {
      name = "fix-backend-search-path.patch";
      url = "https://github.com/SOCI/soci/commit/56c93afc467bdba8ffbe68739eea76059ea62f7a.patch";
      sha256 = "sha256-nC/39pn3Cv5e65GgIfF3l64/AbCsfZHPUPIWETZFZAY=";
    })
  ];

  # Do not build static libraries
  cmakeFlags = [ "-DSOCI_STATIC=OFF" "-DCMAKE_CXX_STANDARD=11" "-DSOCI_TESTS=off" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    sqlite
    postgresql
    boost
  ];

  meta = with lib; {
    description = "Database access library for C++";
    homepage = "http://soci.sourceforge.net/";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
