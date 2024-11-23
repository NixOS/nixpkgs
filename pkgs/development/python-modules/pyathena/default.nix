{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  fastparquet,
  fetchPypi,
  fsspec,
  hatchling,
  pandas,
  pyarrow,
  python-dateutil,
  pythonOlder,
  sqlalchemy,
  tenacity,
}:

buildPythonPackage rec {
  pname = "pyathena";
  version = "3.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-paFTmhPGr2qz1CK425tbSHEbexcl+lqmgoL6RZmfC2o=";
  };

  build-system = [ hatchling ];

  dependencies = [
    boto3
    botocore
    fsspec
    tenacity
    python-dateutil
  ];

  optional-dependencies = {
    pandas = [ pandas ];
    sqlalchemy = [ sqlalchemy ];
    arrow = [ pyarrow ];
    fastparquet = [ fastparquet ];
  };

  # Nearly all tests depend on a working AWS Athena instance,
  # therefore deactivating them.
  # https://github.com/laughingman7743/PyAthena/#testing
  doCheck = false;

  pythonImportsCheck = [ "pyathena" ];

  meta = with lib; {
    description = "Python DB API 2.0 (PEP 249) client for Amazon Athena";
    homepage = "https://github.com/laughingman7743/PyAthena/";
    changelog = "https://github.com/laughingman7743/PyAthena/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
