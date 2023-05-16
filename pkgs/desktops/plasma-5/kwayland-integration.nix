{ mkDerivation
, extra-cmake-modules
, kguiaddons
, kidletime
, kwayland
, kwindowsystem
, qtbase
, wayland-protocols
, wayland-scanner
, wayland
}:

mkDerivation {
  pname = "kwayland-integration";
  nativeBuildInputs = [ extra-cmake-modules wayland-scanner ];
  buildInputs = [ kguiaddons kidletime kwindowsystem kwayland qtbase wayland-protocols wayland ];
<<<<<<< HEAD

  meta = {
    description = "Integration plugins for various KDE frameworks for the Wayland windowing system";
    homepage = "https://invent.kde.org/plasma/kwayland-integration";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
