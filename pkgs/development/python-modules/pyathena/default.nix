{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, boto3
, botocore
, pandas
, tenacity
}:

buildPythonPackage rec {
  pname = "pyathena";
  version = "2.3.0";

  src = fetchPypi {
    pname = "PyAthena";
    inherit version;
    sha256 = "08fl653yayvqi991zvcai5ifcxwy9ip6xh0cr3lbimggjnjgwsl5";
  };

  # Nearly all tests depend on a working AWS Athena instance,
  # therefore deactivating them.
  # https://github.com/laughingman7743/PyAthena/#testing
  doCheck = false;

  propagatedBuildInputs = [
    boto3
    botocore
    pandas
    tenacity
  ];

  meta = with lib; {
    homepage = "https://github.com/laughingman7743/PyAthena/";
    license = licenses.mit;
    description = "Python DB API 2.0 (PEP 249) client for Amazon Athena";
    maintainers = with maintainers; [ turion ];
  };
}
