{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, guile
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "guile-commonmark";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "OrangeShark";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qYDcIiObKOU8lmcfk327LMPx/2Px9ecI3QLrSWWLxMo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
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
