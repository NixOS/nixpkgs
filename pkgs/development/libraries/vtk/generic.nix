{ majorVersion, minorVersion, sourceSha256, patchesToFetch ? [] }:
{ stdenv, lib, fetchurl, cmake
, double-conversion, eigen, expat, gl2ps, glew, fmt_8, freetype, jsoncpp, hdf5, libpng, libtheora, libtiff, libxml2, lz4, libogg, netcdf, proj_7, pugixml, sqlite, utf8cpp
, libGLU, libGL, libX11, xorgproto, libXt
, fetchpatch
, enableQt ? false, qtbase, qtx11extras, qttools
, enablePython ? false, pythonInterpreter ? throw "vtk: Python support requested, but no python interpreter was given."
# Darwin support
, Cocoa, OpenGL
}:

let
  inherit (lib) optionalString optionals optional;

  pythonMajor = lib.substring 0 1 pythonInterpreter.pythonVersion;

in stdenv.mkDerivation rec {
  pname = "vtk${optionalString enableQt "-qvtk"}";
  version = "${majorVersion}.${minorVersion}";

  src = fetchurl {
    url = "https://www.vtk.org/files/release/${majorVersion}/VTK-${version}.tar.gz";
    sha256 = sourceSha256;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    double-conversion
    eigen
    expat
    gl2ps
    glew
    fmt_8
    freetype
    jsoncpp
    hdf5
    libpng
    libtheora
    libtiff
    libxml2
    lz4
    libogg
    netcdf
    proj_7
    pugixml
    sqlite
    utf8cpp
  ] ++ optionals enableQt [ qtbase qtx11extras qttools ]
    ++ optionals stdenv.isLinux [
      libGLU
      libGL
      libX11
      xorgproto
      libXt
    ] ++ optionals stdenv.isDarwin [
      Cocoa
    ] ++ optional enablePython [
      pythonInterpreter
    ];

  patches = map fetchpatch patchesToFetch;

  dontWrapQtApps = true;

  # Shared libraries don't work, because of rpath troubles with the current
  # nixpkgs cmake approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-fPIC"
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-D${if lib.versionOlder version "9.0" then "VTK_USE_SYSTEM_LIBRARIES" else "VTK_USE_EXTERNAL"}=ON"
    "-D${if lib.versionOlder version "9.0" then "VTK_USE_SYSTEM_PEGTL" else "VTK_MODULE_USE_EXTERNAL_VTK_pegtl"}=OFF" # not packaged in nixpkgs
    "-D${if lib.versionOlder version "9.0" then "VTK_USE_SYSTEM_LIBHARU" else "VTK_MODULE_USE_EXTERNAL_VTK_libharu"}=OFF" # requires patches
    "-DOPENGL_INCLUDE_DIR=${libGL}/include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DVTK_VERSIONED_INSTALL=OFF"
    "-DVTK_MODULE_USE_EXTERNAL_VTK_exprtk=OFF"
    "-DVTK_MODULE_USE_EXTERNAL_VTK_cgns=OFF"
    "-DVTK_MODULE_USE_EXTERNAL_VTK_ioss=OFF"
  ] ++ optionals (lib.versionOlder version "8.0") [
    "-DVTK_USE_SYSTEM_LIBPROJ4=OFF" # an older version
    "-DVTK_USE_SYSTEM_NETCDF=OFF" # fails to detect
    "-DVTK_USE_SYSTEM_HDF5=OFF" # needs a different version
    "-DVTK_USE_SYSTEM_GL2PS=OFF" # needs an older version
  ] ++ optionals (lib.versionOlder version "9.0") [
    "-DVTK_USE_SYSTEM_LIBPROJ=OFF" # buggy include paths
    "-DVTK_USE_SYSTEM_PUGIXML=OFF" # fails to detect
    "-DVTK_USE_SYSTEM_OGG=OFF" # undefined symbols during linking
    "-DVTK_USE_SYSTEM_THEORA=OFF" # undefined symbols during linking
    "-DVTK_USE_SYSTEM_JSONCPP=OFF" # undefined symbols during linking
  ] ++ optionals enableQt [
    "-D${if lib.versionOlder version "9.0" then "VTK_Group_Qt:BOOL=ON" else "VTK_GROUP_ENABLE_Qt:STRING=YES"}"
  ] ++ optionals (enableQt && lib.versionOlder version "8.0") [
    "-DVTK_QT_VERSION=5"
  ]
    ++ optionals stdenv.isDarwin [ "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks" ]
    ++ optionals enablePython [
      "-DVTK_WRAP_PYTHON:BOOL=ON"
      "-DVTK_PYTHON_VERSION:STRING=${pythonMajor}"
    ];

  postPatch = lib.optionalString (lib.versionOlder version "9.0")
  # https://gitlab.kitware.com/vtk/vtk/-/issues/18033
  ''
    sed -i Rendering/FreeType/vtkFreeTypeTools.cxx -e '1i#define FT_CALLBACK_DEF( x )  static  x'
    sed -i Rendering/FreeTypeFontConfig/vtkFontConfigFreeTypeTools.cxx -e '1i#define FT_CALLBACK_DEF( x )  static  x'
  '' + optionalString stdenv.isDarwin ''
    sed -i 's|COMMAND vtkHashSource|COMMAND "DYLD_LIBRARY_PATH=''${VTK_BINARY_DIR}/lib" ''${VTK_BINARY_DIR}/bin/vtkHashSource-${majorVersion}|' ./Parallel/Core/CMakeLists.txt
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/' ./ThirdParty/libxml2/vtklibxml2/xmlschemas.c
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/g' ./ThirdParty/libxml2/vtklibxml2/xpath.c
  '';

  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.isDarwin && lib.versionOlder version "9.0") [
    # duplicate symbol '_exodus_unused_symbol_dummy_1' in:
    #     CMakeFiles/vtkexodusII.dir/src/ex_create_par.c.o
    #     CMakeFiles/vtkexodusII.dir/src/ex_open_par.c.o
    "-fcommon"
  ];

  meta = with lib; {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = "https://www.vtk.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp tfmoraes lheckemann ];
    platforms = with platforms; unix;
  };
}
