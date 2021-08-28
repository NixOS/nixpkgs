{
  mkDerivation,
  extra-cmake-modules,
  avahi, qtbase, qttools,
}:

mkDerivation {
  name = "kdnssd";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ avahi qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
