{
  lib,
  buildPythonPackage,
  dask,
  fastparquet,
  fetchFromGitHub,
  pandas,
  pyarrow,
  pythonOlder,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "intake-parquet";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "intake-parquet";
    tag = version;
    hash = "sha256-6OZPevpa3T/7p7X77Dib4My07oqksw9m0ELTLXwYJ70=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  # Break circular dependency
  pythonRemoveDeps = [ "intake" ];

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    pandas
    dask
    fastparquet
    pyarrow
  ];

  doCheck = false;

  #pythonImportsCheck = [ "intake_parquet" ];

  meta = {
    description = "Parquet plugin for Intake";
    homepage = "https://github.com/intake/intake-parquet";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
