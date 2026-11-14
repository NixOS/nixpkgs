{
  lib,
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  passagemath-setup,
  passagemath-environment,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-pari-seadata-small";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
  ];
  buildInputs = with pkgs; [
    # No external libraries required.
  ];
  dependencies = [
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_pari_seadata_small";
    inherit version;
    hash = "sha256-b27PNbvH5xMUDWGfVcq9eWoVGzCW0s25GGtkFlOLLC4=";
  };

  meta = {
    description = "passagemath: Computational Number Theory with PARI/GP: seadata_small";
    longDescription = ''
      `passagemath-pari-seadata-small` provides the seadata_small files
      for use with `passagemath-pari`.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
