{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, guile
<<<<<<< HEAD
, libevent
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-fibers";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wingo";
    repo = "fibers";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-jJKA5JEHsmqQ/IKb1aNmOtoVaGKNjcgTKyo5VCiJbXM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo # for makeinfo
  ];

  buildInputs = [
    guile
    libevent
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];
=======
    hash = "sha256-3q1mJImce96Dn37UbofaNHj54Uzs1p4XyMNzpu3PdXQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    guile
    texinfo
  ];

  autoreconfPhase = "./autogen.sh";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/wingo/fibers";
    description = "Concurrent ML-like concurrency for Guile";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
<<<<<<< HEAD
    platforms = guile.meta.platforms;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
