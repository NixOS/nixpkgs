{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pkgs,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "berkeleydb";
  version = "18.1.16";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eCsaEzCPNjdfP0RgI3tzVtmb5cTGjFhcVG1w21FKKt0=";
  };

  build-system = [ setuptools ];

  # Every test currently fails with:
  # berkeleydb.db.DBRunRecoveryError: (-30973, 'BDB0087 DB_RUNRECOVERY: Fatal error, run database recovery -- BDB1546 unable to join the environment')
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  # See: https://github.com/NixOS/nixpkgs/pull/311198/files#r1597746759
  env = {
    BERKELEYDB_INCDIR = "${lib.getDev pkgs.db}/include";
    BERKELEYDB_LIBDIR = "${lib.getLib pkgs.db}/lib";
  };

  meta = {
    description = "Python bindings for Oracle Berkeley DB";
    homepage = "https://www.jcea.es/programacion/pybsddb.htm";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
