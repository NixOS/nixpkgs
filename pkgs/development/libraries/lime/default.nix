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
<<<<<<< HEAD
  version = "5.2.98";
=======
  version = "5.2.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-LdwXBJpwSA/PoCXL+c1pcX1V2Fq/eR6nNmwBKDM1Vr8=";
=======
    sha256 = "sha256-WQ6AcJpQSvWR5m2edVNji5u6ZiS4QOH45vQN2q+39NU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    homepage = "https://www.linphone.org/technical-corner/lime";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
