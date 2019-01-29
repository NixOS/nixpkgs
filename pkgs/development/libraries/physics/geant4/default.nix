{ enableMultiThreading ? true
, enableG3toG4         ? false
, enableInventor       ? false
, enableGDML           ? false
, enableQT             ? false
, enableXM             ? false
, enableOpenGLX11      ? true
, enableRaytracerX11   ? false

# Standard build environment with cmake.
, stdenv, fetchurl, cmake

# Optional system packages, otherwise internal GEANT4 packages are used.
, clhep ? null # not packaged currently
, expat
, zlib

# For enableGDML.
, xercesc

# For enableQT.
, qtbase

# For enableXM.
, motif

# For enableInventor
, coin3d
, soxt
, libXpm

# For enableQT, enableXM, enableOpenGLX11, enableRaytracerX11.
, libGLU_combined
, xlibsWrapper
, libXmu
}:

stdenv.mkDerivation rec {
  version = "10.4.1";
  name = "geant4-${version}";

  src = fetchurl{
    url = "http://cern.ch/geant4-data/releases/geant4.10.04.p01.tar.gz";
    sha256 = "a3eb13e4f1217737b842d3869dc5b1fb978f761113e74bd4eaf6017307d234dd";
  };

  cmakeFlags = [
    "-DGEANT4_INSTALL_DATA=OFF"
    "-DGEANT4_USE_GDML=${if enableGDML then "ON" else "OFF"}"
    "-DGEANT4_USE_G3TOG4=${if enableG3toG4 then "ON" else "OFF"}"
    "-DGEANT4_USE_QT=${if enableQT then "ON" else "OFF"}"
    "-DGEANT4_USE_XM=${if enableXM then "ON" else "OFF"}"
    "-DGEANT4_USE_OPENGL_X11=${if enableOpenGLX11 then "ON" else "OFF"}"
    "-DGEANT4_USE_INVENTOR=${if enableInventor then "ON" else "OFF"}"
    "-DGEANT4_USE_RAYTRACER_X11=${if enableRaytracerX11 then "ON" else "OFF"}"
    "-DGEANT4_USE_SYSTEM_CLHEP=${if clhep != null then "ON" else "OFF"}"
    "-DGEANT4_USE_SYSTEM_EXPAT=${if expat != null then "ON" else "OFF"}"
    "-DGEANT4_USE_SYSTEM_ZLIB=${if zlib != null then "ON" else "OFF"}"
    "-DGEANT4_BUILD_MULTITHREADED=${if enableMultiThreading then "ON" else "OFF"}"
  ] ++ stdenv.lib.optionals enableInventor [
    "-DINVENTOR_INCLUDE_DIR=${coin3d}/include"
    "-DINVENTOR_LIBRARY_RELEASE=${coin3d}/lib/libCoin.so"
  ];

  enableParallelBuilding = true;
  nativeBuildInputs =  [ cmake ];
  buildInputs = [ clhep expat zlib libGLU_combined xlibsWrapper libXmu ]
    ++ stdenv.lib.optionals enableGDML [ xercesc ]
    ++ stdenv.lib.optionals enableXM [ motif ]
    ++ stdenv.lib.optionals enableQT [ qtbase ]
    ++ stdenv.lib.optionals enableInventor [ libXpm coin3d soxt ];

  postFixup = ''
    # Don't try to export invalid environment variables.
    sed -i 's/export G4\([A-Z]*\)DATA/#export G4\1DATA/' "$out"/bin/geant4.sh
  '';

  setupHook = ./geant4-hook.sh;

  passthru = {
    data = import ./datasets.nix { inherit stdenv fetchurl; };
  };

  # Set the myriad of envars required by Geant4 if we use a nix-shell.
  shellHook = ''
    source $out/nix-support/setup-hook
  '';

  meta = with stdenv.lib; {
    description = "A toolkit for the simulation of the passage of particles through matter";
    longDescription = ''
      Geant4 is a toolkit for the simulation of the passage of particles through matter.
      Its areas of application include high energy, nuclear and accelerator physics, as well as studies in medical and space science.
      The two main reference papers for Geant4 are published in Nuclear Instruments and Methods in Physics Research A 506 (2003) 250-303, and IEEE Transactions on Nuclear Science 53 No. 1 (2006) 270-278.
    '';
    homepage = http://www.geant4.org;
    license = licenses.g4sl;
    maintainers = with maintainers; [ tmplt ];
    platforms = platforms.linux;
  };
}
