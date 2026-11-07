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
  pname = "passagemath-gap-pkg-transgrp-data";
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
    pname = "passagemath_gap_pkg_transgrp_data";
    inherit version;
    hash = "sha256-6cfXruCpHjmV/PgNQQVr/HloYVT5kkWoTebAJ5Jj5sU=";
  };

  meta = {
    description = "passagemath: Computational Group Theory with GAP: transgrp data";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
