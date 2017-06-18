{
  mkDerivation,
  extra-cmake-modules,
  kidletime, kwayland, kwindowsystem, qtbase,
}:

mkDerivation {
  name = "kwayland-integration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kidletime kwindowsystem kwayland qtbase ];
}
