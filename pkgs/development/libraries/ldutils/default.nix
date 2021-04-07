{ mkDerivation
, lib
, fetchFromGitLab
, qtcharts
, qtsvg
, qmake
}:

mkDerivation rec {
  pname = "ldutils";
  version = "1.03";

  src = fetchFromGitLab {
    owner = "ldutils-projects";
    repo = pname;
    rev = "v_${version}";
    sha256 = "0pi05py71hh5vlhl0kjh9wxmd7yixw10s0kr2wb4l4c0abqxr82j";
  };

  buildInputs = [
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
