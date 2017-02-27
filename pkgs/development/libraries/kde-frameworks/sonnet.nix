{ kdeFramework, lib
, extra-cmake-modules
, hunspell, qtbase, qttools
}:

kdeFramework {
  name = "sonnet";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ hunspell qtbase ];
}
