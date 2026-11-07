{
  buildPythonPackage,
  fetchPypi,
  lib,
  passagemath-environment,
  passagemath-setup,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-gap-pkg-factint-data";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
    passagemath-setup
  ];

  dependencies = [
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_gap_pkg_factint_data";
    inherit version;
    hash = "sha256-AB8mjI1d8DfbiD9wSLM5tLHD402it+pPfOcxE5j7Ysc=";
  };

  meta = {
    description = "passagemath: Computational Group Theory with GAP: factint data";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
