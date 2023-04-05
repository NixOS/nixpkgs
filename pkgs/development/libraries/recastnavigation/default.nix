{ stdenv, lib, fetchFromGitHub, cmake, libGL, SDL2, libGLU, catch }:

stdenv.mkDerivation rec {
  pname = "recastai";
  # use latest revision for the CMake build process and OpenMW
  # OpenMW use e75adf86f91eb3082220085e42dda62679f9a3ea
  version = "unstable-2023-01-02";

  src = fetchFromGitHub {
    owner = "recastnavigation";
    repo = "recastnavigation";
    rev = "405cc095ab3a2df976a298421974a2af83843baf";
    sha256 = "sha256-WVzDI7+UuAl10Tm1Zjkea/FMk0cIe7pWg0iyFLbwAdI=";
  };

  postPatch = ''
    cp ${catch}/include/catch/catch.hpp Tests/catch.hpp

    # https://github.com/recastnavigation/recastnavigation/issues/524
    substituteInPlace CMakeLists.txt \
      --replace '\$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Expects SDL2.framework in specific location, which we don't have
    # Change where SDL2 headers are searched for to match what we do have
    substituteInPlace RecastDemo/CMakeLists.txt \
      --replace 'include_directories(''${SDL2_LIBRARY}/Headers)' 'include_directories(${SDL2.dev}/include/SDL2)'
  '';

  doCheck = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libGL SDL2 libGLU ];

  meta = with lib; {
    homepage = "https://github.com/recastnavigation/recastnavigation";
    description = "Navigation-mesh Toolset for Games";
    license = licenses.zlib;
    maintainers = with maintainers; [ marius851000 ];
    platforms = platforms.all;
  };
}
