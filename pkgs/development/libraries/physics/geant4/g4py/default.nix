{ stdenv, fetchurl

# The target version of Geant4
, geant4

# Python (obviously) and boost::python for wrapping.
, python
, boost
}:

let
  buildG4py = 
    { version, src, geant4}:

    stdenv.mkDerivation rec {
      inherit version src geant4;
      name = "g4py-${version}";

      # ./configure overwrites $PATH, which clobbers everything.
      patches = [ ./configure.patch ];
      patchFlags = "-p0";

      configurePhase = ''
        export PYTHONPATH=$PYTHONPATH:${geant4}/lib64:$prefix

        source ${geant4}/share/Geant4-*/geant4make/geant4make.sh
        cd environments/g4py

        ./configure linux64 --prefix=$prefix \
                            --with-g4install-dir=${geant4} \
                            --with-python-incdir=${python}/include/python${python.majorVersion} \
                            --with-python-libdir=${python}/lib \
                            --with-boost-incdir=${boost.dev}/include \
                            --with-boost-libdir=${boost.out}/lib
      '';

      enableParallelBuilding = true;
      buildInputs = [ geant4 boost python ];

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
    };

    fetchGeant4 = import ../fetch.nix {
      inherit stdenv fetchurl;
    };

in {
  v10_0_2 = buildG4py {
    inherit (fetchGeant4.v10_0_2) version src;
    geant4 = geant4.v10_0_2;
  };
}
