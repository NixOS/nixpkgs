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
  pname = "passagemath-pari-galdata";
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
    pname = "passagemath_pari_galdata";
    inherit version;
    hash = "sha256-xruC8tH5nQ9nq0xbfLOwFQ36Lb1qauf81gp9u3A+TRY=";
  };

  meta = {
    description = "passagemath: Computational Number Theory with PARI/GP: Galois group data";
    longDescription = ''
      `passagemath-pari-galdata` provides Galois group data for use with
      `passagemath-pari`.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
