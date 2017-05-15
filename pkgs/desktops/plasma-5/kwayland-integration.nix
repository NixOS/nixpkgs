{ mkDerivation , extra-cmake-modules , kidletime , kwayland , kwindowsystem }:

mkDerivation {
  name = "kwayland-integration";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kidletime kwindowsystem kwayland ];
}
