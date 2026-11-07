{
  buildPythonPackage,
  fetchPypi,
  lib,
  passagemath-conf-nix,
  platformdirs,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-environment";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    passagemath-conf-nix
    platformdirs
  ];

  src = fetchPypi {
    pname = "passagemath_environment";
    inherit version;
    hash = "sha256-N6dB1NP1uUED/DxAwuRSChQejV4lyHqI6U8B6gQ7paI=";
  };

  meta = {
    description = "Runtime environment configuration for the modular SageMath library";
    longDescription = ''
      This module defines variables inside python, consummed by Sage packages.
      Sage packages define each variables in this fallback order:
        1. Takes value of an environment variable of the same name if it exists;
        2. Takes value of what is defined in the sage.config module (which is pkgs.python3Packages.passagemath-conf)
        3. Takes the value of what the Sage package decide.
    '';

    homepage = "https://passagemath.org/";
    license = lib.licenses.gpl2Plus;
  };
}
