{
  lib,
  stdenv,
  autoreconfHook,
  intltool,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20240304";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = pname;
    rev = version;
    sha256 = "sha256-vXG9aa6Zdv5R7q62tpFaUIw4MVnT/jWwZ+jw1S9K7MM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
  ];

  meta = with lib; {
    description = "Monitor database for DDCcontrol";
    homepage = "https://github.com/ddccontrol/ddccontrol-db";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.pakhfn ];
  };
}
