{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, kcrash, kdbusaddons, kdoctools, ki18n, kwindowsystem
}:

kdeFramework {
  name = "kservice";
  setupHook = ./setup-hook.sh;
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcrash kdbusaddons ];
  propagatedBuildInputs = [ kconfig kcoreaddons ki18n kwindowsystem ];
  propagatedUserEnvPkgs = [ kcoreaddons ];
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
    ./0002-no-canonicalize-path.patch
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
