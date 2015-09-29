{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kcoreaddons
, kcrash
, kdbusaddons
, kwindowsystem
, qtx11extras
}:

kdeFramework {
  name = "kglobalaccel";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig kcoreaddons kcrash kdbusaddons kwindowsystem qtx11extras ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kglobalaccel5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
