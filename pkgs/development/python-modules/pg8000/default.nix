{
  lib,
  buildPythonPackage,
  fetchPypi,
  passlib,
  python-dateutil,
  scramp,
  hatchling,
  versioningit,
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.31.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5+zOQzmJHyewsi4veeue/kQRi9OEIHNZ/Bg1D3iKzgA=";
  };

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [
    passlib
    python-dateutil
    scramp
  ];

  # Tests require a running PostgreSQL instance
  doCheck = false;

  pythonImportsCheck = [ "pg8000" ];

  meta = {
    description = "Python driver for PostgreSQL";
    homepage = "https://github.com/tlocke/pg8000";
    changelog = "https://github.com/tlocke/pg8000#release-notes";
    license = with lib.licenses; [ bsd3 ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
