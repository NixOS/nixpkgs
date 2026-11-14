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

  pythonImportsCheck = [
    "sage"
    "sage.features"
    "sage.misc.package"
    "sage.misc.package_dir"
    "sage.misc.temporary_file"
    # "sage.misc.viewer" # Module not found in passagemath's sources
  ];

  meta = {
    description = "passagemath: System and software environment";
    homepage = "https://passagemath.org/";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
