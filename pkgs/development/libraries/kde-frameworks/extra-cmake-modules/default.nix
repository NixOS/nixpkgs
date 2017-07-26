{ mkDerivation, lib, copyPathsToStore, cmake, pkgconfig }:

mkDerivation {
  name = "extra-cmake-modules";

  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);

  outputs = [ "out" ];  # this package has no runtime components

  propagatedNativeBuildInputs = [ cmake pkgconfig ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    homepage = "http://www.kde.org";
    license = licenses.bsd2;
    maintainers = [ maintainers.ttuegel ];
  };
}
