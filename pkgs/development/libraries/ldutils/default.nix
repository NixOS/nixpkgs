{
  mkDerivation,
  lib,
  fetchFromGitLab,
  libsForQt5,
  cmake,
}:
mkDerivation rec {
  pname = "ldutils";
  version = "1.15";

  src = fetchFromGitLab {
    owner = "ldutils-projects";
    repo = pname;
    rev = "4fc416f694ce888c5bd4c4432a7730bb6260475c";
    #rev = "v_${version}";
    hash = "sha256-UMDayvz9RlcR4HVJNn7tN4FKbiKAFRSPaK0osA6OGTI=";
  };

  buildInputs = with libsForQt5.qt5; [
    qtcharts
    qtsvg
  ];

  nativeBuildInputs = [
    cmake
  ];

  qmakeFlags = [ "ldutils.pro" ];

  LDUTILS_LIB = placeholder "out";
  LDUTILS_INCLUDE = placeholder "out";

  meta = with lib; {
    description = "Headers and link library for other ldutils projects";
    homepage = "https://gitlab.com/ldutils-projects/ldutils";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.linux;
  };
}
