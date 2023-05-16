{ bctoolbox
, cmake
, fetchFromGitLab
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "belr";
<<<<<<< HEAD
  version = "5.2.98";
=======
  version = "5.1.55";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-4keVUAsTs1DAhOfV71VD28I0PEHnyvW95blplY690LY=";
=======
    sha256 = "sha256-0JDwNKqPkzbXqDhgMV+okPMHPFJwmLwLsDrdD55Jcs4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with lib; {
    description = "Belledonne Communications' language recognition library. Part of the Linphone project.";
    homepage = "https://gitlab.linphone.org/BC/public/belr";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
