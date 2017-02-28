{ kdeFramework, lib
, extra-cmake-modules, perl, qtbase, qttools
}:

kdeFramework {
  name = "syntax-highlighting";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules perl qttools ];
  buildInputs = [ qtbase ];
}
