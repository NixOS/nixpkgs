{ bctoolbox
, cmake
, fetchFromGitLab
, sqlite
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bzrtp";
<<<<<<< HEAD
  version = "5.2.98";
=======
  version = "5.2.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-p3r8GVhxShTanEI/tS8Dq59I7VKMDX1blz6S236XFqQ=";
=======
    hash = "sha256-nrnGmJxAeobejS6zdn5Z/kOFOxyepZcxW/G4nXAt2DY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ bctoolbox sqlite ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
<<<<<<< HEAD
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];
=======
  cmakeFlags = [ "-DENABLE_STATIC=NO" "-DCMAKE_C_FLAGS=-Wno-error=cast-function-type" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=stringop-overflow"
<<<<<<< HEAD
    "-Wno-error=unused-parameter"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "An opensource implementation of ZRTP keys exchange protocol. Part of the Linphone project.";
    homepage = "https://gitlab.linphone.org/BC/public/bzrtp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
