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

  # tests
  pytestCheckHook,
  pandas,
  pyarrow,
}:

buildPythonPackage (finalAttrs: {
  pname = "adbc-driver-sqlite";
  version = "1.13.0";
  pyproject = true;

  # Updates should be correlated with arrow-adbc top-level attribute, so:
  # nixpkgs-update: no auto update
  src = fetchPypi {
    pname = "adbc_driver_sqlite";
    inherit (finalAttrs) version;
    hash = "sha256-bBhqoESe7ZXDYal0EKAseMEGGcTSCdxAcOd+dp+Od5w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    adbc-driver-manager
    importlib-resources
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    pyarrow
  ];
  env.ADBC_SQLITE_LIBRARY = "libadbc_driver_sqlite${stdenv.hostPlatform.extensions.sharedLibrary}";
  preBuild = ''
    cp ${lib.getLib arrow-adbc}/lib/$ADBC_SQLITE_LIBRARY .
    chmod u+w $ADBC_SQLITE_LIBRARY
  '';

  pythonImportsCheck = [
    "adbc_driver_sqlite"
  ];

  meta = {
    description = "ADBC driver for working with SQLite";
    homepage = "https://pypi.org/project/adbc-driver-sqlite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
