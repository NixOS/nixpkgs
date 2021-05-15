{ bctoolbox
, belle-sip
, cmake
, fetchFromGitLab
, lib
, soci
, sqlite
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "lime";
  version = "4.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1fsldk7gxagxkbkzksz6dz8a8dmix1lxfy8nvvp0m355pzgqj6lb";
  };

  buildInputs = [ bctoolbox soci belle-sip sqlite ];
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
