{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kcoreaddons
, kcrash
, kdbusaddons
, kwindowsystem
, makeKDEWrapper
, qtx11extras
}:

kdeFramework {
  name = "kglobalaccel";
  nativeBuildInputs = [ extra-cmake-modules makeKDEWrapper ];
  buildInputs = [ kconfig kcoreaddons kcrash kdbusaddons ];
  propagatedBuildInputs = [ kwindowsystem qtx11extras ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kglobalaccel5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
