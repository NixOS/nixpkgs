{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  adbc-driver-manager,
  importlib-resources,
  arrow-adbc,
}:

buildPythonPackage (finalAttrs: {
  pname = "adbc-driver-postgresql";
  version = "1.13.0";
  pyproject = true;

  # Updates should be correlated with arrow-adbc top-level attribute, so:
  # nixpkgs-update: no auto update
  src = fetchPypi {
    pname = "adbc_driver_postgresql";
    inherit (finalAttrs) version;
    hash = "sha256-7Ou/MuSEHUh0IpYUyY99z2DsZXiCZB1ssgzVSyp0I78=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    adbc-driver-manager
    importlib-resources
  ];

  # Tests require several unknown pytest fixture `postgres_uri`
  doCheck = false;

  env.ADBC_POSTGRESQL_LIBRARY = "libadbc_driver_postgresql${stdenv.hostPlatform.extensions.sharedLibrary}";
  preBuild = ''
    cp ${lib.getLib arrow-adbc}/lib/$ADBC_POSTGRESQL_LIBRARY .
    chmod u+w $ADBC_POSTGRESQL_LIBRARY
  '';

  pythonImportsCheck = [
    "adbc_driver_postgresql"
  ];

  meta = {
    description = "libpq-based ADBC driver for working with PostgreSQL";
    homepage = "https://pypi.org/project/adbc-driver-postgresql";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
