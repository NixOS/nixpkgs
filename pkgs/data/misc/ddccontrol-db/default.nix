{ lib, stdenv
, autoreconfHook
, intltool
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20240209";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = pname;
    rev = version;
    sha256 = "sha256-Jmq8W9LHL+B4mY0meI9CtKvJw6NnF83kDaUG8Hbsj4Q=";
  };

  nativeBuildInputs = [ autoreconfHook intltool ];

  meta = with lib; {
    description = "Monitor database for DDCcontrol";
    homepage = "https://github.com/ddccontrol/ddccontrol-db";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.pakhfn ];
  };
}
