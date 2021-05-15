{ cmake
, fetchFromGitHub
, sqlite
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "soci";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "SOCI";
    repo = pname;
    rev = version;
    sha256 = "sha256-d4GtxDaB+yGfyCnbvnLRUYcrPSMkUF7Opu6+SZd8opM=";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DSOCI_STATIC=OFF" "-DCMAKE_CXX_STANDARD=11" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sqlite ];

  meta = with lib; {
    description = "Database access library for C++";
    homepage = "http://soci.sourceforge.net/";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
