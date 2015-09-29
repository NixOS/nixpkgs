{ kdeFramework, lib
, extra-cmake-modules
, hunspell
}:

kdeFramework {
  name = "sonnet";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ hunspell ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
