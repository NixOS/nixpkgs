{ lib
, mkDerivation
, fetchFromGitLab

, cmake
, extra-cmake-modules

, ki18n
, kirigami2
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "kirigami-addons";
  version = "21.05";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pwkpag15mvzhd3hvdwx0a8ajwq9j30r6069vsx85bagnag3zanh";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    ki18n
    kirigami2
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Add-ons for the Kirigami framework";
    homepage = "https://invent.kde.org/libraries/kirigami-addons";
    # https://invent.kde.org/libraries/kirigami-addons/-/blob/b197d98fdd079b6fc651949bd198363872d1be23/src/treeview/treeviewplugin.cpp#L1-5
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}

