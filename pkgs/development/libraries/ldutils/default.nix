{ mkDerivation
, lib
, fetchFromGitLab
, qtbase
, qtcharts
, qtsvg
, qmake
}:

mkDerivation rec {
  pname = "ldutils";
  version = "1.01";

  src = fetchFromGitLab {
    owner = "ldutils-projects";
    repo = pname;
    rev = "v_${version}";
    sha256 = "09k2d5wj70xfr3sb4s9ajczq0lh65705pggs54zqqqjxazivbmgk";
  };

  buildInputs = [
    qtbase
    qtcharts
    qtsvg
  ];

  nativeBuildInputs = [
    qmake
  ];

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
