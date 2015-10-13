{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, kcrash, kdbusaddons, kdoctools, ki18n, kwindowsystem
}:

kdeFramework {
  name = "kservice";
  setupHook = ./setup-hook.sh;
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcoreaddons kcrash kdbusaddons ];
  propagatedBuildInputs = [ kconfig ki18n kwindowsystem ];
  patches = [
    ./kservice-kbuildsycoca-follow-symlinks.patch
    ./kservice-kbuildsycoca-no-canonicalize-path.patch
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
