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
  pythonOlder,
  sqlalchemy,
  tenacity,
}:

buildPythonPackage rec {
  pname = "pyathena";
  version = "3.8.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mcYIYOgww4UM0CAcdtOD12pp53clPdDqN85bLRHGDag=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    boto3
    botocore
    fsspec
    tenacity
  ];

  passthru.optional-dependencies = {
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
    maintainers = with maintainers; [ turion ];
  };
}
