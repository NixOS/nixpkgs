{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, autoreconfHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, guile
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-xcb";
<<<<<<< HEAD
  version = "unstable-2017-05-29";
=======
  version = "1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mwitmer";
    repo = pname;
<<<<<<< HEAD
    rev = "db7d5a393cc37a56f66541b3f33938b40c6f35b3";
    hash = "sha256-zbIsEIPwNJ1YXMZTDw2DfzufC+IZWfcWgZHbuv7bhJs=";
  };

  nativeBuildInputs = [
    autoreconfHook
=======
    rev = version;
    hash = "sha256-8iaYil2wiqnu9p7Gj93GE5akta1A0zqyApRwHct5RSs=";
  };

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pkg-config
  ];
  buildInputs = [
    guile
    texinfo
  ];

  configureFlags = [
<<<<<<< HEAD
    "--with-guile-site-dir=$(out)/${guile.siteDir}"
    "--with-guile-site-ccache-dir=$(out)/${guile.siteCcacheDir}"
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
=======
    "--with-guile-site-dir=$out/share/guile/site"
    "--with-guile-site-ccache-dir=$out/share/guile/site"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    homepage = "https://github.com/mwitmer/guile-xcb";
    description = "XCB bindings for Guile";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
<<<<<<< HEAD
    platforms = guile.meta.platforms;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
