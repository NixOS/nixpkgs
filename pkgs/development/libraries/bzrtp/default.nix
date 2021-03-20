{ bctoolbox
, cmake
, fetchFromGitLab
, sqlite
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bzrtp";
  version = "4.4.34";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-Zv/B7OXQayD1cdJkpz40FTXqhSLcqKVPJvRXX/HSVfo=";
  };

  buildInputs = [ bctoolbox sqlite ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type";

  meta = with lib; {
    description = "An opensource implementation of ZRTP keys exchange protocol";
    homepage = "https://gitlab.linphone.org/BC/public/bzrtp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
