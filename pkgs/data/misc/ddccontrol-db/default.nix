{ lib, stdenv
, autoconf
, automake
, libtool
, intltool
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20210804";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = version;
    sha256 = "sha256-+PTw4bDJhWyuEae5ShkIL/KvQ29+gU46iE2RdtTWb8M=";
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
