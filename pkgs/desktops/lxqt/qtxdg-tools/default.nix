{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, libqtxdg
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "qtxdg-tools";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "sha256-NUSeXEJ6zjTz6p/8R6YTVfPQEnk1ukZ2ikdDdkaPeSw=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    libqtxdg
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/qtxdg-tools";
    description = "libqtxdg user tools";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
