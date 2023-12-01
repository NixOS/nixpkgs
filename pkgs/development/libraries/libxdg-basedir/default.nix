{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libxdg-basedir";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "devnev";
    repo = pname;
    rev = "refs/tags/libxdg-basedir-${version}";
    hash = "sha256-ewtUKDdE6k9Q9hglWwhbTU3DTxvIN41t+zf2Gch9Dkk=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "Implementation of the XDG Base Directory specification";
    homepage = "https://github.com/devnev/libxdg-basedir";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.unix;
  };
}
