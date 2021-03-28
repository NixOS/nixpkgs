{
  mkDerivation, lib,
  extra-cmake-modules,
  avahi, qtbase, qttools,
}:

mkDerivation {
  name = "kdnssd";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ avahi qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
