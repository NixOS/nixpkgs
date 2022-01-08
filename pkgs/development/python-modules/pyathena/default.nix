{ lib
, buildPythonPackage
, fetchPypi
, boto3
, botocore
, pandas
, tenacity
}:

buildPythonPackage rec {
  pname = "pyathena";
  version = "2.3.2";

  src = fetchPypi {
    pname = "PyAthena";
    inherit version;
    sha256 = "20a473c52e76a211c427d2f711af0a04804a70fc036ab884780e42e0dc2025f7";
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
