{ kdeFramework, lib, copyPathsToStore, cmake, pkgconfig }:

kdeFramework {
  name = "extra-cmake-modules";

  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);

  outputs = [ "out" ];  # this package has no runtime components

  propagatedNativeBuildInputs = [ cmake pkgconfig ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    platforms = lib.platforms.linux;
    homepage = "http://www.kde.org";
    license = licenses.bsd2;
    maintainers = [ maintainers.ttuegel ];
  };
}
