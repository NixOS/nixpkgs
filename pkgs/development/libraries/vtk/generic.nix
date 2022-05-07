{ majorVersion, minorVersion, sourceSha256, patchesToFetch ? [] }:
{ stdenv, lib, fetchurl, cmake, libGLU, libGL, libX11, xorgproto, libXt
, fetchpatch
, enableQt ? false, wrapQtAppsHook, qtbase, qtx11extras, qttools
, enablePython ? false, pythonInterpreter ? throw "vtk: Python support requested, but no python interpreter was given."
, cgns
, cli11
, diy
, double-conversion
, eigen
, exodusII
, expat
, exprtk
, fides
, fmt_8
, freetype
, gl2ps
, glew
# , h5part
, hdf5
, ioss
, libjpeg
, jsoncpp
, kissfft
# , kwiml
# , kwsys
, libharu
, proj
, libxml2
# , loguru
, lz4
, xz
# , metaio
# , mpi4py
, netcdf
, nlohmann_json
, libogg
, pegtl
, libpng
, pugixml
, sqlite
, libtheora
, libtiff
, utf8cpp
# , verdict
# , xdmf3
, zfp
, zlib
# Darwin support
, Cocoa, CoreServices, DiskArbitration, IOKit, CFNetwork, Security, GLUT, OpenGL
, ApplicationServices, CoreText, IOSurface, ImageIO, xpc, libobjc
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

  buildInputs = [ libpng libtiff ]
    ++ optionals enableQt [ qtbase qtx11extras qttools ]
    ++ optionals stdenv.isLinux [
      libGLU
      libGL
      libX11
      xorgproto
      libXt
    ] ++ optionals (lib.versionAtLeast version "9.0") [
      cgns
      cli11
      diy
      double-conversion
      eigen
      exodusII # Does not support non-vendored use
      expat
      exprtk
      fides
      fmt_8
      freetype
      gl2ps
      glew
      # h5part
      hdf5
      ioss
      libjpeg
      jsoncpp
      # kissfft # Does not support non-vendored use
      # kwiml
      # kwsys # Does not support non-vendored use
      libharu
      proj
      libxml2
      # loguru
      lz4
      xz # for lzma
      # metaio
      # mpi4py
      netcdf
      nlohmann_json
      libogg
      pegtl
      libpng
      pugixml
      sqlite
      libtheora
      libtiff
      utf8cpp
      # verdict # Does not support non-vendored use
      # xdmf3
      zfp
      zlib
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
    ] ++ optional enablePython [
      pythonInterpreter
    ];
  propagatedBuildInputs = optionals stdenv.isDarwin [ libobjc ];

  patches = map fetchpatch patchesToFetch;

  preBuild = ''
    export LD_LIBRARY_PATH="$(pwd)/lib";
  '';

  dontWrapQtApps = true;

  # Shared libraries don't work, because of rpath troubles with the current
  # nixpkgs cmake approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-fPIC"
    "-DCMAKE_CXX_FLAGS=-fPIC"
  ] ++ optionals (lib.versionOlder version "9.0") [
    "-DVTK_USE_SYSTEM_PNG=ON"
    "-DVTK_USE_SYSTEM_TIFF=1"
  ] ++ optionals (lib.versionAtLeast version "9.0") [
    "-DVTK_USE_EXTERNAL:BOOL=ON"
  ] ++ [
    "-DOPENGL_INCLUDE_DIR=${libGL}/include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
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

  postPatch = optionalString stdenv.isDarwin ''
    sed -i 's|COMMAND vtkHashSource|COMMAND "DYLD_LIBRARY_PATH=''${VTK_BINARY_DIR}/lib" ''${VTK_BINARY_DIR}/bin/vtkHashSource-${majorVersion}|' ./Parallel/Core/CMakeLists.txt
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/' ./ThirdParty/libxml2/vtklibxml2/xmlschemas.c
    sed -i 's/fprintf(output, shift)/fprintf(output, "%s", shift)/g' ./ThirdParty/libxml2/vtklibxml2/xpath.c
  '' + optionalString (lib.versionAtLeast version "9.0") ''
    # libharu 2.4.0 has not been released yet, probably never will be, and there
    # do not appear to be important fixes in the dev branch VTK uses.
    # https://github.com/libharu/libharu/compare/RELEASE_2_3_0...master
    substituteInPlace ThirdParty/libharu/CMakeLists.txt \
      --replace '2.4.0' '2.3.0'
  '';

  preFixup = ''
    for lib in $out/lib/libvtk*.so; do
      ln -s $lib $out/lib/"$(basename "$lib" | sed -e 's/-[[:digit:]]*.[[:digit:]]*//g')"
    done

    mv $out/include/vtk-${majorVersion}/* $out/include
    rmdir $out/include/vtk-${majorVersion}
    ln -s $out/include $out/include/vtk-${majorVersion}
  '';

  meta = with lib; {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = "https://www.vtk.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp tfmoraes lheckemann ];
    platforms = with platforms; unix;
    # /nix/store/xxxxxxx-apple-framework-Security/Library/Frameworks/Security.framework/Headers/Authorization.h:192:7: error: variably modified 'bytes' at file scope
    broken = stdenv.isDarwin && (lib.versions.major majorVersion == "7" || lib.versions.major majorVersion == "8");
  };
}
