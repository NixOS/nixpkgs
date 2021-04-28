{ lib, stdenv
, autoconf
, automake
, libtool
, intltool
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20201221";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = version;
    sha256 = "1sryyjjad835mwc7a2avbij6myln8b824kjdr78gc9hh3p16929b";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  buildInputs =
    [
      autoconf
      automake
      libtool
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
