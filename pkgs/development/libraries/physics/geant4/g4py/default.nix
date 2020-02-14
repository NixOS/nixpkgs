{ stdenv, cmake, xercesc

# The target version of Geant4
, geant4

# Python (obviously) and boost::python for wrapping.
, python
, boost
}:

let
  # g4py does not support MT and will fail to build against MT geant
  geant4_nomt = geant4.override { enableMultiThreading = false; };
  boost_python = boost.override { enablePython = true; inherit python; };
in

stdenv.mkDerivation {
  inherit (geant4_nomt) version src;
  pname = "g4py";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ geant4_nomt xercesc boost_python python ];

  GEANT4_INSTALL = geant4_nomt;

  postPatch = ''
    cd environments/g4py
  '';

  preConfigure = ''
    # Fix for boost 1.67+
    substituteInPlace CMakeLists.txt \
    --replace "find_package(Boost)" "find_package(Boost 1.40 REQUIRED COMPONENTS python${builtins.replaceStrings ["."] [""] python.pythonVersion})"
    for f in `find . -name CMakeLists.txt`; do
      substituteInPlace "$f" \
        --replace "boost_python" "\''${Boost_LIBRARIES}"
    done
  '';

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  # Make sure we set PYTHONPATH
  shellHook = ''
    source $out/nix-support/setup-hook
  '';

  meta = {
    description = "Python bindings and utilities for Geant4";
    longDescription = ''
      Geant4 is a toolkit for the simulation of the passage of particles
      through matter.  Its areas of application include high energy,
      nuclear and accelerator physics, as well as studies in medical and
      space science.  The two main reference papers for Geant4 are
      published in Nuclear Instruments and Methods in Physics Research A
      506 (2003) 250-303, and IEEE Transactions on Nuclear Science 53 No. 1
      (2006) 270-278.
    '';
    homepage = http://www.geant4.org;
    license = stdenv.lib.licenses.g4sl;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
