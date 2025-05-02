{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, six
}:

buildPythonPackage rec {
  pname = "bson";
  version = "0.5.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14355m3dchz446fl54ym78bn4wi20hddx1614f8rl4sin0m1nlfn";
  };

  propagatedBuildInputs = [
    python-dateutil
    six
  ];

  # 0.5.10 was not tagged, https://github.com/py-bson/bson/issues/108
  doCheck = false;

  pythonImportsCheck = [ "bson" ];

  meta = with lib; {
    description = "BSON codec for Python";
    homepage = "https://github.com/py-bson/bson";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
