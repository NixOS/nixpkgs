{ enableMultiThreading ? false
, enableG3toG4         ? false
, enableInventor       ? false
, enableGDML           ? false
, enableQT             ? false
, enableXM             ? false
, enableOpenGLX11      ? false
, enableRaytracerX11   ? false

# Standard build environment with cmake.
, stdenv, fetchurl, cmake

# Optional system packages, otherwise internal GEANT4 packages are used.
, clhep ? null
, expat ? null
, zlib  ? null

# For enableGDML.
, xercesc ? null

# For enableQT.
, qt ? null # qt4SDK or qt5SDK

# For enableXM.
, motif ? null # motif or lesstif

# For enableInventor
, coin3d
, soxt
, libXpm ? null

# For enableQT, enableXM, enableOpenGLX11, enableRaytracerX11.
, libGLU_combined ? null
, xlibsWrapper ? null
, libXmu ? null
}:

# G4persistency library with support for GDML
assert enableGDML -> xercesc != null;

# If enableQT, Qt4/5 User Interface and Visualization drivers.
assert enableQT -> qt != null;

# Motif User Interface and Visualisation drivers.
assert enableXM -> motif != null;

# OpenGL/X11 User Interface and Visualisation drivers.
assert enableQT || enableXM || enableOpenGLX11 || enableRaytracerX11 -> libGLU_combined   != null;
assert enableQT || enableXM || enableOpenGLX11 || enableRaytracerX11 -> xlibsWrapper    != null;
assert enableQT || enableXM || enableOpenGLX11 || enableRaytracerX11 -> libXmu != null;
assert enableInventor -> libXpm != null;

let
  buildGeant4 =
    { version, src, multiThreadingCapable ? false }:

    stdenv.mkDerivation rec {
      inherit version src;
      name = "geant4-${version}";

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
        "-DINVENTOR_INCLUDE_DIR=${coin3d}/include"
        "-DINVENTOR_LIBRARY_RELEASE=${coin3d}/lib/libCoin.so"
      ] ++ stdenv.lib.optional multiThreadingCapable
        "-DGEANT4_BUILD_MULTITHREADED=${if enableMultiThreading then "ON" else "OFF"}";

      enableParallelBuilding = true;
      buildInputs = [ cmake clhep expat zlib xercesc qt motif libGLU_combined xlibsWrapper libXmu libXpm coin3d soxt ];
      propagatedBuildInputs = [ clhep expat zlib xercesc qt motif libGLU_combined xlibsWrapper libXmu libXpm coin3d soxt ];

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
        platforms = platforms.all;
      };
    };

  fetchGeant4 = import ./fetch.nix {
    inherit stdenv fetchurl;
  };

in {
  v10_0_2 = buildGeant4 {
    inherit (fetchGeant4.v10_0_2) version src;
    multiThreadingCapable = true;
  };

  v10_4_1 = buildGeant4 {
    inherit (fetchGeant4.v10_4_1) version src;
    multiThreadingCapable = true;
  };
}
