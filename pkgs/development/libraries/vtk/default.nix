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
  majorVersion = "8.2";
  minorVersion = "0";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "vtk-${os (qtLib != null) "qvtk-"}${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/VTK-${version}.tar.gz";
    sha256 = "1fspgp8k0myr6p2a6wkc21ldcswb4bvmb484m12mxgk1a9vxrhrl";
  };

  patches = [
    # Fix compilation with Qt 5.15
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/vtk/files/vtk-8.2.0-qt-5.15.patch?id=3ca9613d7ad604c93d714e29b116952561e4e41c";
      sha256 = "sha256-BFjoKws1hVD3Ly9RS4lGN62J6RTyI1E8ATHrZdzg7ds=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libtiff ]
    ++ optionals (qtLib != null) (with qtLib; [ qtbase qtx11extras qttools ])
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
  # nixpkgs cmake approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [ "-DCMAKE_C_FLAGS=-fPIC" "-DCMAKE_CXX_FLAGS=-fPIC" "-DVTK_USE_SYSTEM_TIFF=1" "-DOPENGL_INCLUDE_DIR=${libGL}/include" ]
    ++ optional (qtLib != null) [ "-DVTK_Group_Qt:BOOL=ON" ]
    ++ optional stdenv.isDarwin [ "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks" ]
    ++ optional enablePython [ "-DVTK_WRAP_PYTHON:BOOL=ON" ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|COMMAND vtkHashSource|COMMAND "DYLD_LIBRARY_PATH=''${VTK_BINARY_DIR}/lib" ''${VTK_BINARY_DIR}/bin/vtkHashSource-${majorVersion}|' ./Parallel/Core/CMakeLists.txt
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/' ./ThirdParty/libxml2/vtklibxml2/xmlschemas.c
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/g' ./ThirdParty/libxml2/vtklibxml2/xpath.c
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = "https://www.vtk.org/";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
