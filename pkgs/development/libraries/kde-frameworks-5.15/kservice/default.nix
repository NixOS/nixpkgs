{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, kcrash, kdbusaddons, kdoctools, ki18n, kwindowsystem
}:

kdeFramework {
  name = "kservice";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcoreaddons kcrash kdbusaddons ];
  propagatedBuildInputs = [ kconfig ki18n kwindowsystem ];
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
    ./0002-no-canonicalize-path.patch
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
