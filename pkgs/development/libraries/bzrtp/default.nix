{ bctoolbox
, cmake
, fetchFromGitLab
, sqlite
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bzrtp";
  version = "5.0.55";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-+rUDKdMUeVnGsvG7NgQkN6e+DY2bThIyuPTvqxG6uDk=";
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
