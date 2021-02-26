{ bctoolbox
, belle-sip
, cmake
, fetchFromGitLab
, soci
, sqlite
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "lime";
  version = "4.4.21";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-3whr2KSAULRe3McgOtJlA3NEPF8NO6YHp+4vqeMPT5I=";
  };

  buildInputs = [ bctoolbox soci belle-sip sqlite ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with lib; {
    description = "End-to-end encryption library for instant messaging";
    homepage = "http://www.linphone.org/technical-corner/lime";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
