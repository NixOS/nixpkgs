{
  cmake,
  fetchFromGitLab,
  fetchpatch,
  sqlite,
  boost,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "bc-soci";
  version = "linphone-5.2.6";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "soci";
    rev = "d26d42eae02051ccbc53e8684cbc8b5aeb6cea13";
    sha256 = "sha256-L40HxTmYIM7eAtD4/8Ag8EddKorOcUUtTRywxpQKpcE=";
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
    description = "Database access library for C++. Belledonne Communications' fork for Linphone";
    homepage = "https://gitlab.linphone.org/BC/public/external/soci";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ thibaultlemaire ];
  };
}
