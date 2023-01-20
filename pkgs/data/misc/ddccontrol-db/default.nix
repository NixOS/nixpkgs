{ lib, stdenv
, autoconf
, automake
, libtool
, intltool
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20220903";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = version;
    sha256 = "sha256-OmroJ2AEQdELE2Wuk1qPXzp+/9RUUULrEAdEpmXrJxw=";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [ autoconf automake ];
  buildInputs =
    [
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
