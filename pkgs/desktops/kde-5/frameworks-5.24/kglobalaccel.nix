{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kcoreaddons
, kcrash
, kdbusaddons
, kwindowsystem
, makeQtWrapper
, qtx11extras
}:

kdeFramework {
  name = "kglobalaccel";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kcrash kdbusaddons kwindowsystem qtx11extras
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kglobalaccel5"
  '';
}
