{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, kcoreaddons
, kdeclarative
, kdecoration
, plasma-framework
, plasma-workspace
, libSM
, qtx11extras
, kwindowsystem
, libdbusmenu
, wrapQtAppsHook
}:

stdenv.mkDerivation {
  pname = "applet-window-appmenu";
  version = "unstable-2022-06-27";

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = "applet-window-appmenu";
    rev = "1de99c93b0004b80898081a1acfd1e0be807326a";
    hash = "sha256-PLlZ2qgdge8o1mZOiPOXSmTQv1r34IUmWTmYFGEzNTI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kcoreaddons
    kdeclarative
    kdecoration
    kwindowsystem
    plasma-framework
    plasma-workspace
    libSM
    qtx11extras
    libdbusmenu
  ];

  meta = with lib; {
    description = "Plasma 5 applet in order to show window menu in your panels";
    homepage = "https://github.com/psifidotos/applet-window-appmenu";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ greydot ];
    platforms = platforms.linux;
  };
}
