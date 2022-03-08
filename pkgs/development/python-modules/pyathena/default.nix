{ lib
, buildPythonPackage
, fetchPypi
, boto3
, botocore
, pandas
, tenacity
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyathena";
  version = "2.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyAthena";
    inherit version;
    sha256 = "sha256-2Z0KjJm6cWhMTKXa2zBs3Ef2i/e1tqQYZx5sSKIT9a4=";
  };

  propagatedBuildInputs = [
    boto3
    botocore
    pandas
    tenacity
  ];

  # Nearly all tests depend on a working AWS Athena instance,
  # therefore deactivating them.
  # https://github.com/laughingman7743/PyAthena/#testing
  doCheck = false;

  pythonImportsCheck = [
    "pyathena"
  ];

  meta = with lib; {
    homepage = "https://github.com/laughingman7743/PyAthena/";
    license = licenses.mit;
    description = "Python DB API 2.0 (PEP 249) client for Amazon Athena";
    maintainers = with maintainers; [ turion ];
  };
}
