{ bctoolbox
, belle-sip
, cmake
, fetchFromGitLab
, lib
, bc-soci
, sqlite
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "lime";
  version = "5.2.6";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-WQ6AcJpQSvWR5m2edVNji5u6ZiS4QOH45vQN2q+39NU=";
  };

  buildInputs = [
    # Made by BC
    bctoolbox
    belle-sip

    # Vendored by BC
    bc-soci

    sqlite
  ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DENABLE_STATIC=NO" # Do not build static libraries
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  meta = with lib; {
    description = "End-to-end encryption library for instant messaging. Part of the Linphone project.";
    homepage = "http://www.linphone.org/technical-corner/lime";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
