{ stdenv, lib, copyPathsToStore, src, version, cmake }:

stdenv.mkDerivation {
  name = "extra-cmake-modules-${version}";

  inherit src;

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
