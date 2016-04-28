{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, kcrash, kdbusaddons, kdoctools, ki18n, kwindowsystem
}:

kdeFramework {
  name = "kservice";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  propagatedNativeBuildInputs = [ extra-cmake-modules ];
  nativeBuildInputs = [ kdoctools ];
  propagatedBuildInputs = [ kconfig kcoreaddons kcrash kdbusaddons ki18n kwindowsystem ];
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
    ./0002-no-canonicalize-path.patch
  ];
}
