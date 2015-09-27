{ mkDerivation, lib
, extra-cmake-modules
, hunspell
}:

mkDerivation {
  name = "sonnet";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ hunspell ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
