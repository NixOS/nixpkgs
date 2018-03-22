{ stdenv, fetchurl, fetchpatch, cmake, libGLU_combined, libX11, xproto, libXt
, qtLib ? null
# Darwin support
, Cocoa, CoreServices, DiskArbitration, IOKit, CFNetwork, Security, GLUT, OpenGL
, ApplicationServices, CoreText, IOSurface, cf-private, ImageIO, xpc, libobjc }:

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "7.0";
  minorVersion = "0";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "vtk-${os (qtLib != null) "qvtk-"}${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/VTK-${version}.tar.gz";
    sha256 = "1hrjxkcvs3ap0bdhk90vymz5pgvxmg7q6sz8ab3wsyddbshr1abq";
  };

  buildInputs =
    if !stdenv.isDarwin
    then [ cmake libGLU_combined libX11 xproto libXt ] ++ optional (qtLib != null) qtLib
    else [ cmake qtLib xpc CoreServices DiskArbitration IOKit cf-private
           CFNetwork Security ApplicationServices CoreText IOSurface ImageIO
           OpenGL GLUT ];
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ Cocoa libobjc ];


  preBuild = ''
    export LD_LIBRARY_PATH="$(pwd)/lib";
  '';

  # Shared libraries don't work, because of rpath troubles with the current
  # nixpkgs camke approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [ "-DCMAKE_C_FLAGS=-fPIC" "-DCMAKE_CXX_FLAGS=-fPIC" ]
    ++ optional (qtLib != null) [ "-DVTK_USE_QT:BOOL=ON" ]
    ++ optional stdenv.isDarwin [ "-DBUILD_TESTING:BOOL=OFF"
                                  "-DCMAKE_OSX_SYSROOT="
                                  "-DCMAKE_OSX_DEPLOYMENT_TARGET="
                                  "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks" ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|COMMAND vtkHashSource|COMMAND "DYLD_LIBRARY_PATH=''${VTK_BINARY_DIR}/lib" ''${VTK_BINARY_DIR}/bin/vtkHashSource-7.0|' ./Parallel/Core/CMakeLists.txt
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/' ./ThirdParty/libxml2/vtklibxml2/xmlschemas.c
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/g' ./ThirdParty/libxml2/vtklibxml2/xpath.c
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = http://www.vtk.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
