{ lib
, boto3
, botocore
, buildPythonPackage
, fastparquet
, fetchPypi
, fsspec
, pandas
, poetry-core
, pyarrow
, pythonOlder
, sqlalchemy
, tenacity
}:

buildPythonPackage rec {
  pname = "pyathena";
  version = "3.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7m6hdRNIlCCa8sa+GFm3vkNx93QfqnpY+fl5Bf9qc6Q=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    boto3
    botocore
    fsspec
    tenacity
  ];

  passthru.optional-dependencies = {
    pandas = [
      pandas
    ];
    sqlalchemy = [
      sqlalchemy
    ];
    arrow = [
      pyarrow
    ];
    fastparquet = [
      fastparquet
    ];
  };

  # Nearly all tests depend on a working AWS Athena instance,
  # therefore deactivating them.
  # https://github.com/laughingman7743/PyAthena/#testing
  doCheck = false;

  pythonImportsCheck = [
    "pyathena"
  ];

  meta = with lib; {
    description = "Python DB API 2.0 (PEP 249) client for Amazon Athena";
    homepage = "https://github.com/laughingman7743/PyAthena/";
    changelog = "https://github.com/laughingman7743/PyAthena/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ turion ];
  };
}
