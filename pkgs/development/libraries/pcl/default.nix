{ stdenv, fetchFromGitHub, cmake, qhull, flann, boost, vtk, eigen, pkgconfig, qt4
, libusb1, libpcap, libXt, libpng, Cocoa, AGL, cf-private
}:

stdenv.mkDerivation rec {
  name = "pcl-1.8.0";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = name;
    sha256 = "1pki4y7mc2dryxc8wa7rs4hg74qab80rpy90jnw3j8fzf09kxcll";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake qhull flann boost eigen pkgconfig libusb1 libpcap
                  libpng vtk qt4 libXt ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa AGL cf-private ];
  cmakeFlags = stdenv.lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_SYSROOT=" "-DCMAKE_OSX_DEPLOYMENT_TARGET=" ];

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    NIX_CFLAGS_COMPILE=$(echo "$NIX_CFLAGS_COMPILE" | sed "s,[[:space:]]*-F$NIX_STORE/[[:alnum:]]*-CF-osx-[[:digit:].]*/Library/Frameworks,,g")
    sed -i 's,^\(      target_link_libraries("''${LIB_NAME}" "-framework Cocoa")\),\1\n      target_link_libraries("''${LIB_NAME}" "/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation"),' visualization/CMakeLists.txt
    sed -i 's,^\(set(SUBSYS_DEPS common io kdtree geometry search)\),\1\nset(CMAKE_OSX_SYSROOT "")\nset(CMAKE_OSX_DEPLOYMENT_TARGET ""),' visualization/CMakeLists.txt
  '';

  meta = {
    homepage = http://pointclouds.org/;
    description = "Open project for 2D/3D image and point cloud processing";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
