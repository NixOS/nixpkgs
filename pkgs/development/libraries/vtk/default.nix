{ stdenv, fetchurl, cmake, libGLU, libGL, libX11, xorgproto, libXt, libtiff
, fetchpatch
, qtLib ? null
, enablePython ? false, python ? null
# Darwin support
, Cocoa, CoreServices, DiskArbitration, IOKit, CFNetwork, Security, GLUT, OpenGL
, ApplicationServices, CoreText, IOSurface, ImageIO, xpc, libobjc }:

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "7.1";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "vtk-${os (qtLib != null) "qvtk-"}${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/VTK-${version}.tar.gz";
    sha256 = "0nm7xwwj7rnsxjdv2ssviys8nhci4n9iiiqm2y14s520hl2dsp1d";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.kitware.com/vtk/vtk/-/commit/706f1b397df09a27ab8981ab9464547028d0c322.diff";
      sha256 = "1q3pi5h40g05pzpbqp75xlgzvbfvyw8raza51svmi7d8dlslqybx";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libtiff ]
    ++ optional (qtLib != null) qtLib
    ++ optionals stdenv.isLinux [ libGLU libGL libX11 xorgproto libXt ]
    ++ optionals stdenv.isDarwin [ xpc Cocoa CoreServices DiskArbitration IOKit
                                   CFNetwork Security ApplicationServices CoreText
                                   IOSurface ImageIO OpenGL GLUT ]
    ++ optional enablePython [
      python
    ];
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ libobjc ];

  preBuild = ''
    export LD_LIBRARY_PATH="$(pwd)/lib";
  '';

  # Shared libraries don't work, because of rpath troubles with the current
  # nixpkgs camke approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [ "-DCMAKE_C_FLAGS=-fPIC" "-DCMAKE_CXX_FLAGS=-fPIC" "-DVTK_USE_SYSTEM_TIFF=1" "-DOPENGL_INCLUDE_DIR=${libGL}/include" ]
    ++ optional (qtLib != null) [ "-DVTK_USE_QT:BOOL=ON" ]
    ++ optional stdenv.isDarwin [ "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks" ]
    ++ optional enablePython [ "-DVTK_WRAP_PYTHON:BOOL=ON" ];

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
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
