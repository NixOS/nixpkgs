{ bctoolbox
, belr
, cmake
, fetchFromGitLab
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "belcard";
  version = "5.2.98";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-pRNJ1bDS2v0Cn+6cxMeFa0JQ27UZR6kCI9P6gQ5W2GA=";
  };

  buildInputs = [ bctoolbox belr ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DENABLE_STATIC=NO" # Do not build static libraries
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  meta = with lib; {
    description = "C++ library to manipulate VCard standard format. Part of the Linphone project.";
    homepage = "https://gitlab.linphone.org/BC/public/belcard";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
