{ lib, stdenv, autoconf, automake, libtool, intltool, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20210812";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = version;
    sha256 = "sha256-dRqyjDC9yNkNOnYQ9fkWPlnyzSqIZ4zxZ2T7t8Bu9FE=";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  buildInputs = [ autoconf automake libtool intltool ];

  meta = with lib; {
    description = "Monitor database for DDCcontrol";
    homepage = "https://github.com/ddccontrol/ddccontrol-db";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.pakhfn ];
  };
}
