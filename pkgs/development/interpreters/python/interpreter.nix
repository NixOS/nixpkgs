{ stdenv
, pkgs
, python
#, pythonConfig ? (self: super: {})
, overrides ? (self: super: {})
}:

let
  inherit (stdenv) lib;

  # Package set
  packages = let

    inherit (lib) fix' extends fold;

    pythonPackages = self: import ./support.nix {
      inherit pkgs python setuptools;
    } self;

    commonConfiguration = import ../../../top-level/python-packages.nix { inherit pkgs stdenv; };

  #in fix' (fold extends [ overrides commonConfiguration pythonPackages ]);
  in fix' (extends overrides (extends commonConfiguration pythonPackages));

  # Function to build an environment
  buildEnv = import ./wrapper.nix {
    inherit stdenv python;
    inherit (pkgs) buildEnv makeWrapper;
  };

  # Function to build an environment, but accepting only a list of packages
  withPackages = import ./with-packages.nix {
    inherit buildEnv;
    pythonPackages = packages;
  };

  # Derivation with scripts for building wrappers
  wrapPython = import ./wrap-python.nix {
    inherit lib python;
    inherit (pkgs) makeSetupHook makeWrapper;
  };

  # Setuptools derivation
  setuptools = import ../../python-modules/setuptools {
    inherit stdenv lib python wrapPython;
    inherit (pkgs) fetchurl;
  };

  # Function to build a package that doesn't use setuptools
  mkPythonDerivation = import ./mk-python-derivation.nix {
    inherit lib python wrapPython setuptools;
    inherit (pkgs) unzip ensureNewerSourcesHook;
  };

  # Function to build a package that uses setuptools or installs a wheel
  buildPythonPackage = lib.makeOverridable ( import ./build-python-package.nix {
    inherit lib python mkPythonDerivation;
    bootstrapped-pip = import ../../python-modules/bootstrapped-pip {
      inherit stdenv python;
      inherit (pkgs) fetchurl makeWrapper unzip;
    };
  });

in {
# For each Python interpreter version we have this set.
  pkgs = packages;
  inherit withPackages;
  inherit buildEnv;
  inherit mkPythonDerivation;
  inherit buildPythonPackage;
}
