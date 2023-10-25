{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation {
  pname = "parson";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "kgabis";
    repo = "parson";
    rev = "60c37844d7a1c97547812cac3423d458c73e60f9"; # upstream doesn't use tags
    hash = "sha256-SbM0kqRtdcz1s+pUTW7VPMY1O6zdql3bao19Rk4t470=";
  };

  nativeBuildInputs = [ meson ninja ];

  meta = with lib; {
    description = "Lightweight JSON library written in C";
    homepage = "https://github.com/kgabis/parson";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
