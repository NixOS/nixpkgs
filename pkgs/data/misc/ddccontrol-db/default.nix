{ lib, stdenv
, autoreconfHook
, intltool
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20230627";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = pname;
    rev = version;
    sha256 = "sha256-gRkYoDDD3QCsfZcpIqNAZBAb/si975vyd0NnlWNHob8=";
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
