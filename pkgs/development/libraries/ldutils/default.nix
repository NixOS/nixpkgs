{ mkDerivation
, lib
, fetchFromGitLab
, qtcharts
, qtsvg
, qmake
}:

mkDerivation rec {
  pname = "ldutils";
  version = "1.10";

  src = fetchFromGitLab {
    owner = "ldutils-projects";
    repo = pname;
    rev = "v_${version}";
    sha256 = "sha256-fP+tZY+ayaeuxPvywO/639sNE+IwrxaEJ245q9HTOCU=";
  };

  buildInputs = [
    qtcharts
    qtsvg
  ];

  nativeBuildInputs = [
    qmake
  ];

  qmakeFlags = [ "ldutils.pro" ];

  LDUTILS_LIB=placeholder "out";
  LDUTILS_INCLUDE=placeholder "out";

  meta = with lib; {
    description = "Headers and link library for other ldutils projects";
    homepage = "https://gitlab.com/ldutils-projects/ldutils";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.linux;
  };
}
