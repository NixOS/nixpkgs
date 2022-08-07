{ lib
, boto3
, botocore
, buildPythonPackage
, fetchPypi
, pandas
, pythonOlder
, tenacity
}:

buildPythonPackage rec {
  pname = "pyathena";
  version = "2.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyAthena";
    inherit version;
    hash = "sha256-tt7Idp2MuR7DpXDUwtzqmMhQROb3018m/GxeSJia1j4=";
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
    description = "Python DB API 2.0 (PEP 249) client for Amazon Athena";
    homepage = "https://github.com/laughingman7743/PyAthena/";
    license = licenses.mit;
    maintainers = with maintainers; [ turion ];
  };
}
