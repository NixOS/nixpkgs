{
  lib,
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  qtbase,
}:

mkDerivation {
  pname = "kjs";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    qtbase
  ];
  cmakeFlags = [
    # this can break stuff, see:
    # https://invent.kde.org/frameworks/kjs/-/blob/3c663ad8ac16f8982784a5ebd5d9200e7aa07936/CMakeLists.txt#L36-46
    # However: It shouldn't break much considering plasma 5 is planned to be removed.
    (lib.cmakeBool "KJS_FORCE_DISABLE_PCRE" true)
  ];
}
