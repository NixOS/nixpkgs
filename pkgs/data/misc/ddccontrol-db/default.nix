{ lib, stdenv
, autoconf
, automake
, libtool
, intltool
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20220216";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = version;
    sha256 = "sha256-Nr8OvxbJRf9t2BUtEX3qBAH2BSs6KWLMzSpykiwYsHQ=";
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
