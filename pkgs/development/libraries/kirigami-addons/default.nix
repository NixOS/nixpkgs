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
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wwc0PCY8vNCmmwfIYYQhQea9AYkHakvTaERtazz8npQ=";
=======
    hash = "sha256-ObbpM1gVVFhOIHOla5YS8YYe+JoPgdZ8kJ356wLTJq4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ samueldr matthiasbeyer ];
=======
    maintainers = with maintainers; [ samueldr ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

