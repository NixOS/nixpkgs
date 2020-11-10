{ stdenv, mkDerivation, fetchurl, cmake, libGLU, libGL, libX11, xorgproto, libXt, libtiff
, fetchpatch
, enableQt ? false, qtbase, qtx11extras, qttools
, enablePython ? false, python ? null
# Darwin support
, Cocoa, CoreServices, DiskArbitration, IOKit, CFNetwork, Security, GLUT, OpenGL
, ApplicationServices, CoreText, IOSurface, ImageIO, xpc, libobjc }:

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "9.0";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
in

mkDerivation rec {
  name = "vtk-${os enableQt "qvtk-"}${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/VTK-${version}.tar.gz";
    sha256 = "1ir2lq9i45ls374lcmjzw0nrm5l5hnm1w47lg8g8d0n2j7hsaf8v";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libtiff ]
    ++ optionals enableQt [ qtbase qtx11extras qttools ]
    ++ optionals stdenv.isLinux [
      libGLU
      libGL
      libX11
      xorgproto
      libXt
    ] ++ optionals stdenv.isDarwin [
      xpc
      Cocoa
      CoreServices
      DiskArbitration
      IOKit
      CFNetwork
      Security
      ApplicationServices
      CoreText
      IOSurface
      ImageIO
      OpenGL
      GLUT
    ]
    ++ optional enablePython [
      python
    ];
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ libobjc ];

  preBuild = ''
    export LD_LIBRARY_PATH="$(pwd)/lib";
  '';

  # Shared libraries don't work, because of rpath troubles with the current
  # nixpkgs cmake approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-fPIC"
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-DVTK_USE_SYSTEM_TIFF=1"
    "-DOPENGL_INCLUDE_DIR=${libGL}/include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
  ]
    ++ optionals enableQt [ "-DVTK_Group_Qt:BOOL=ON" ]
    ++ optionals stdenv.isDarwin [ "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks" ]
    ++ optionals enablePython [
      "-DVTK_WRAP_PYTHON:BOOL=ON"
      "-DVTK_PYTHON_VERSION:STRING=3"
    ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|COMMAND vtkHashSource|COMMAND "DYLD_LIBRARY_PATH=''${VTK_BINARY_DIR}/lib" ''${VTK_BINARY_DIR}/bin/vtkHashSource-${majorVersion}|' ./Parallel/Core/CMakeLists.txt
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/' ./ThirdParty/libxml2/vtklibxml2/xmlschemas.c
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/g' ./ThirdParty/libxml2/vtklibxml2/xpath.c
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = "https://www.vtk.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tfmoraes ];
    platforms = with platforms; unix;
  };
}
