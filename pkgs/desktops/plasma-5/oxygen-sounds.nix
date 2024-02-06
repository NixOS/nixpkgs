{ mkDerivation
, extra-cmake-modules
}:

mkDerivation {
  pname = "oxygen-sounds";
  nativeBuildInputs = [ extra-cmake-modules ];
}
