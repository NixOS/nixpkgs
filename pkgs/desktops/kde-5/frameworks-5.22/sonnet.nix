{ kdeFramework, lib
, extra-cmake-modules
, hunspell
}:

kdeFramework {
  name = "sonnet";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ hunspell ];
}
