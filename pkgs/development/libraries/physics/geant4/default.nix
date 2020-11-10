{ enableMultiThreading ? true
, enableG3toG4         ? false
, enableInventor       ? false
, enableGDML           ? false
, enableQT             ? false
, enableXM             ? false
, enableOpenGLX11      ? true
, enablePython         ? false
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

# For enablePython
, boost
, python3
}:

let
  boost_python = boost.override { enablePython = true; python = python3; };
in

stdenv.mkDerivation rec {
  version = "10.6.2";
  pname = "geant4";

  src = fetchurl{
    url = "https://geant4-data.web.cern.ch/geant4-data/releases/geant4.10.06.p02.tar.gz";
    sha256 = "0vznm3pjlbihjy1wsxc4gj229k0dzc283wvil2xghyl08vwdpnpc";
  };

  boost_python_lib = "python${builtins.replaceStrings ["."] [""] python3.pythonVersion}";
  postPatch = ''
    # Fix for boost 1.67+
    substituteInPlace environments/g4py/CMakeLists.txt \
      --replace "find_package(Boost REQUIRED python)" \
                "find_package(Boost REQUIRED COMPONENTS $boost_python_lib)"
    substituteInPlace environments/g4py/G4PythonHelpers.cmake \
      --replace "Boost::python" "Boost::$boost_python_lib"
  '';

  cmakeFlags = [
    "-DGEANT4_INSTALL_DATA=OFF"
    "-DGEANT4_USE_GDML=${if enableGDML then "ON" else "OFF"}"
    "-DGEANT4_USE_G3TOG4=${if enableG3toG4 then "ON" else "OFF"}"
    "-DGEANT4_USE_QT=${if enableQT then "ON" else "OFF"}"
    "-DGEANT4_USE_XM=${if enableXM then "ON" else "OFF"}"
    "-DGEANT4_USE_OPENGL_X11=${if enableOpenGLX11 then "ON" else "OFF"}"
    "-DGEANT4_USE_INVENTOR=${if enableInventor then "ON" else "OFF"}"
    "-DGEANT4_USE_PYTHON=${if enablePython then "ON" else "OFF"}"
    "-DGEANT4_USE_RAYTRACER_X11=${if enableRaytracerX11 then "ON" else "OFF"}"
    "-DGEANT4_USE_SYSTEM_CLHEP=${if clhep != null then "ON" else "OFF"}"
    "-DGEANT4_USE_SYSTEM_EXPAT=${if expat != null then "ON" else "OFF"}"
    "-DGEANT4_USE_SYSTEM_ZLIB=${if zlib != null then "ON" else "OFF"}"
    "-DGEANT4_BUILD_MULTITHREADED=${if enableMultiThreading then "ON" else "OFF"}"
  ] ++ stdenv.lib.optionals (enableMultiThreading && enablePython) [
    "-DGEANT4_BUILD_TLS_MODEL=global-dynamic"
  ] ++ stdenv.lib.optionals enableInventor [
    "-DINVENTOR_INCLUDE_DIR=${coin3d}/include"
    "-DINVENTOR_LIBRARY_RELEASE=${coin3d}/lib/libCoin.so"
  ];

  enableParallelBuilding = true;
  nativeBuildInputs =  [ cmake ];

  buildInputs = [ libGLU xlibsWrapper libXmu ]
    ++ stdenv.lib.optionals enableInventor [ libXpm coin3d soxt motif ]
    ++ stdenv.lib.optionals enablePython [ boost_python python3 ];

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
    homepage = "http://www.geant4.org";
    license = licenses.g4sl;
    maintainers = with maintainers; [ tmplt omnipotententity ];
    platforms = platforms.linux;
  };
}
