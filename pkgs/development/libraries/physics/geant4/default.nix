{ enableMultiThreading ? true
, enableInventor       ? false
, enableQT             ? false # deprecated name
, enableQt             ? enableQT
, enableXM             ? false
, enableOpenGLX11      ? true
, enablePython         ? false
, enableRaytracerX11   ? false

# Standard build environment with cmake.
, lib, stdenv, fetchurl, fetchpatch, cmake

, clhep
, expat
, xercesc
, zlib

# For enableQt.
, qtbase
, wrapQtAppsHook

# For enableXM.
, motif

# For enableInventor
, coin3d
, soxt
, libXpm

# For enableQt, enableXM, enableOpenGLX11, enableRaytracerX11.
, libGLU, libGL
, xlibsWrapper
, libXmu

# For enablePython
, boost
, python3

# For tests
, callPackage
}:

let
  boost_python = boost.override { enablePython = true; python = python3; };
in

lib.warnIf (enableQT != false) "geant4: enableQT is deprecated, please use enableQt"

stdenv.mkDerivation rec {
  version = "11.0.2";
  pname = "geant4";

  src = fetchurl{
    url = "https://cern.ch/geant4-data/releases/geant4-v${version}.tar.gz";
    hash = "sha256-/AONuDcxL3Tj+O/RC108qHqZnUg9TYlZxguKdJIh7GE=";
  };

  cmakeFlags = [
    "-DGEANT4_INSTALL_DATA=OFF"
    "-DGEANT4_USE_GDML=ON"
    "-DGEANT4_USE_G3TOG4=ON"
    "-DGEANT4_USE_QT=${lib.boolToCMakeString enableQt}"
    "-DGEANT4_USE_XM=${lib.boolToCMakeString enableXM}"
    "-DGEANT4_USE_OPENGL_X11=${lib.boolToCMakeString enableOpenGLX11}"
    "-DGEANT4_USE_INVENTOR=${lib.boolToCMakeString enableInventor}"
    "-DGEANT4_USE_PYTHON=${lib.boolToCMakeString enablePython}"
    "-DGEANT4_USE_RAYTRACER_X11=${lib.boolToCMakeString enableRaytracerX11}"
    "-DGEANT4_USE_SYSTEM_CLHEP=ON"
    "-DGEANT4_USE_SYSTEM_EXPAT=ON"
    "-DGEANT4_USE_SYSTEM_ZLIB=ON"
    "-DGEANT4_BUILD_MULTITHREADED=${lib.boolToCMakeString enableMultiThreading}"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DXQuartzGL_INCLUDE_DIR=${libGL.dev}/include"
    "-DXQuartzGL_gl_LIBRARY=${libGL}/lib/libGL.dylib"
  ] ++ lib.optionals (enableMultiThreading && enablePython) [
    "-DGEANT4_BUILD_TLS_MODEL=global-dynamic"
  ] ++ lib.optionals enableInventor [
    "-DINVENTOR_INCLUDE_DIR=${coin3d}/include"
    "-DINVENTOR_LIBRARY_RELEASE=${coin3d}/lib/libCoin.so"
  ];

  nativeBuildInputs =  [
    cmake
  ];

  propagatedNativeBuildInputs = lib.optionals enableQt [
    wrapQtAppsHook
  ];
  dontWrapQtApps = true; # no binaries

  buildInputs = [ libGLU xlibsWrapper libXmu ]
    ++ lib.optionals enableInventor [ libXpm coin3d soxt motif ]
    ++ lib.optionals enablePython [ boost_python python3 ];

  propagatedBuildInputs = [ clhep expat xercesc zlib libGL ]
    ++ lib.optionals enableXM [ motif ]
    ++ lib.optionals enableQt [ qtbase ];

  postFixup = ''
    # Don't try to export invalid environment variables.
    sed -i 's/export G4\([A-Z]*\)DATA/#export G4\1DATA/' "$out"/bin/geant4.sh
  '' + lib.optionalString enableQt ''
    wrapQtAppsHook
  '';

  setupHook = ./geant4-hook.sh;

  passthru = {
    data = callPackage ./datasets.nix {};

    tests = callPackage ./tests.nix {};

    inherit enableQt;
  };

  # Set the myriad of envars required by Geant4 if we use a nix-shell.
  shellHook = ''
    source $out/nix-support/setup-hook
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A toolkit for the simulation of the passage of particles through matter";
    longDescription = ''
      Geant4 is a toolkit for the simulation of the passage of particles through matter.
      Its areas of application include high energy, nuclear and accelerator physics, as well as studies in medical and space science.
      The two main reference papers for Geant4 are published in Nuclear Instruments and Methods in Physics Research A 506 (2003) 250-303, and IEEE Transactions on Nuclear Science 53 No. 1 (2006) 270-278.
    '';
    homepage = "http://www.geant4.org";
    license = licenses.g4sl;
    maintainers = with maintainers; [ omnipotententity veprbl ];
    platforms = platforms.unix;
  };
}
