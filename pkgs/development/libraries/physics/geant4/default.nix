{ enableMultiThreading ? true
, enableG3toG4         ? false
, enableInventor       ? false
, enableGDML           ? false
, enableQT             ? false
, enableXM             ? false
, enableOpenGLX11      ? true
, enableRaytracerX11   ? false

# Standard build environment with cmake.
, stdenv, fetchurl, fetchpatch, cmake

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
, libGLU, libGL
, xlibsWrapper
, libXmu
}:

stdenv.mkDerivation rec {
  version = "10.6.1";
  pname = "geant4";

  src = fetchurl{
    url = "https://geant4-data.web.cern.ch/geant4-data/releases/geant4.10.06.p01.tar.gz";
    sha256 = "0ssxg7dd7vxljb3fdyb0llg7gsxack21qjfsb3n23k107a19yibk";
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

  buildInputs = [ libGLU xlibsWrapper libXmu ]
    ++ stdenv.lib.optionals enableInventor [ libXpm coin3d soxt motif ];

  propagatedBuildInputs = [ clhep expat zlib libGL ]
    ++ stdenv.lib.optionals enableGDML [ xercesc ]
    ++ stdenv.lib.optionals enableXM [ motif ]
    ++ stdenv.lib.optionals enableQT [ qtbase ];

  postFixup = ''
    # Don't try to export invalid environment variables.
    sed -i 's/export G4\([A-Z]*\)DATA/#export G4\1DATA/' "$out"/bin/geant4.sh
  '';

  setupHook = ./geant4-hook.sh;

  passthru = {
    data = import ./datasets.nix {
          inherit stdenv fetchurl;
          geant_version = version;
      };
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
    maintainers = with maintainers; [ tmplt omnipotententity ];
    platforms = platforms.linux;
  };
}
