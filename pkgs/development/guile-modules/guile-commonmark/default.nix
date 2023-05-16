{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, guile
, pkg-config
<<<<<<< HEAD
, texinfo
}:

stdenv.mkDerivation {
  pname = "guile-commonmark";
  version = "unstable-2020-04-30";

  src = fetchFromGitHub {
    owner = "OrangeShark";
    repo = "guile-commonmark";
    rev = "538ffea25ca69d9f3ee17033534ba03cc27ba468";
    hash = "sha256-9cA7iQ/GGEx+HwsdAxKC3IssqkT/Yg8ZxaiIprS5VuI=";
=======
}:

stdenv.mkDerivation rec {
  pname = "guile-commonmark";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "OrangeShark";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qYDcIiObKOU8lmcfk327LMPx/2Px9ecI3QLrSWWLxMo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
<<<<<<< HEAD
    texinfo # for makeinfo
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];
  buildInputs = [
    guile
  ];

  # https://github.com/OrangeShark/guile-commonmark/issues/20
  doCheck = false;

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  meta = with lib; {
    homepage = "https://github.com/OrangeShark/guile-commonmark";
    description = "Implementation of CommonMark for Guile";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = guile.meta.platforms;
  };
}
