{ bctoolbox
, cmake
, fetchFromGitLab
, sqlite
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bzrtp";
  version = "5.2.111";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    hash = "sha256-sLvvQhJ9uVt/dx57xs9ftY/ETi46xmyGDH8372zpqj8=";
  };

  buildInputs = [ bctoolbox sqlite ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=stringop-overflow"
    "-Wno-error=unused-parameter"
  ];

  meta = with lib; {
    description = "An opensource implementation of ZRTP keys exchange protocol. Part of the Linphone project.";
    homepage = "https://gitlab.linphone.org/BC/public/bzrtp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
