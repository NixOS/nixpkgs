{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pkgs,
  python,
}:

buildPythonPackage rec {
  pname = "berkeleydb";
  version = "18.1.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QmNBoWAHqQAtmHpvTZcib46v/8saBIhIgFPTijEnyBo=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  # See: https://github.com/NixOS/nixpkgs/pull/311198/files#r1597746759
  env = {
    BERKELEYDB_INCDIR = "${lib.getDev pkgs.db}/include";
    BERKELEYDB_LIBDIR = "${lib.getLib pkgs.db}/lib";
  };

  meta = with lib; {
    description = "Python bindings for Oracle Berkeley DB";
    homepage = "https://www.jcea.es/programacion/pybsddb.htm";
    license = with licenses; [ bsd3 ];
    maintainers = [ ];
  };
}
