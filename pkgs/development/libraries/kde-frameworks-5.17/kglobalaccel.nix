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
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  buildInputs = [ kconfig kcoreaddons kcrash kdbusaddons ];
  propagatedBuildInputs = [ kwindowsystem qtx11extras ];
  postInstall = ''
    wrapQtProgram "$out/bin/kglobalaccel5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
