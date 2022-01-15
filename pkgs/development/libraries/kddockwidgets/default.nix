{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtx11extras
}:

mkDerivation rec {
  pname = "KDDockWidgets";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7jC0zl5ESwqZXzvFJYmPvRhwFitse05NuYoTgFWiHac=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase qtx11extras ];

  meta = with lib; {
    description = "KDAB's Dock Widget Framework for Qt";
    homepage = "https://www.kdab.com/development-resources/qt-tools/kddockwidgets";
    license = with licenses; [ gpl2Only gpl3Only ];
    maintainers = with maintainers; [ _1000teslas ];
  };
}
