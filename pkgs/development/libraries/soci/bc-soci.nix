{ cmake
, fetchFromGitLab
, fetchpatch
, sqlite
, boost
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bc-soci";
  version = "linphone-4.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "soci";
    rev = "bc8ce0c5628dd48eca6ef5ce0a0a2f52547d88b6";
    sha256 = "sha256-qo26aYp/G2C6UkGA1qkHQwTKD5go7TQ9JWxb9xtbe6M=";
  };

  patches = [
    (fetchpatch {
      name = "fix-backend-search-path.patch";
      url = "https://github.com/SOCI/soci/commit/56c93afc467bdba8ffbe68739eea76059ea62f7a.patch";
      sha256 = "sha256-nC/39pn3Cv5e65GgIfF3l64/AbCsfZHPUPIWETZFZAY=";
    })
  ];

  cmakeFlags = [
    # Do not build static libraries
    "-DSOCI_SHARED=YES"
    "-DSOCI_STATIC=OFF"

    "-DSOCI_TESTS=NO"
    "-DWITH_SQLITE3=YES"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    sqlite
    boost
  ];

  meta = with lib; {
    description = "Database access library for C++. Belledonne Communications' fork for Linphone.";
    homepage = "https://gitlab.linphone.org/BC/public/external/soci";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ thibaultlemaire ];
  };
}
