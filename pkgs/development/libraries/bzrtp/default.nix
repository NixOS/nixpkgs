{ bctoolbox
, cmake
, fetchFromGitLab
, sqlite
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bzrtp";
  version = "5.1.12";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-GsHVuNXzLkbKUaHtnyXAr7bR9Emc55zcmKt3RGjCMtA=";
  };

  buildInputs = [ bctoolbox sqlite ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" "-DCMAKE_C_FLAGS=-Wno-error=cast-function-type" ];

  meta = with lib; {
    description = "An opensource implementation of ZRTP keys exchange protocol. Part of the Linphone project.";
    homepage = "https://gitlab.linphone.org/BC/public/bzrtp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
