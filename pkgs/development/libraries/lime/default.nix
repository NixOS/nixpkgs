{ bctoolbox
, belle-sip
, cmake
, fetchFromGitLab
, lib
, soci
, sqlite
, boost
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "lime";
  version = "5.0.53";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-M+KdauIVsN3c+cEPw4CaMzXnQZwAPNXeJCriuk9NCWM=";
  };

  buildInputs = [ bctoolbox soci belle-sip sqlite boost ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with lib; {
    description = "End-to-end encryption library for instant messaging";
    homepage = "http://www.linphone.org/technical-corner/lime";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
