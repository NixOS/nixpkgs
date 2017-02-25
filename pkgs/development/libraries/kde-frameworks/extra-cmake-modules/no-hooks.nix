{ kdeFramework, lib, copyPathsToStore, cmake }:

kdeFramework {
  name = "extra-cmake-modules";

  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);

  outputs = [ "out" ];  # this package has no runtime components

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    platforms = lib.platforms.linux;
    homepage = "http://www.kde.org";
    license = licenses.bsd2;
    maintainers = [ maintainers.ttuegel ];
  };
}
