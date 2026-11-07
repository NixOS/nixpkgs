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
  pname = "passagemath-gap-pkg-primgrp-data";
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
    pname = "passagemath_gap_pkg_primgrp_data";
    inherit version;
    hash = "sha256-zrPBWXzhw5LG/uRP/d3sAk+BmNxFYpsJSMdgJN6sLnc=";
  };

  meta = {
    description = "passagemath: Computational Group Theory with GAP: primgrp data";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
