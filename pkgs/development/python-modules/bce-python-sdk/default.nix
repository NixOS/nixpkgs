{ lib
, buildPythonPackage
, fetchPypi
, future
, pycryptodome
, six
}:

buildPythonPackage rec {
  pname = "bce-python-sdk";
  version = "0.8.87";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vgTf1HiD/R/1m24zq/vB+Dt2KzacfwePrfe1q0jB0qk=";
  };

  propagatedBuildInputs = [
    future
    pycryptodome
    six
  ];

  # there is no tests
  doCheck = false;

  pythonImportsCheck = [ "baidubce" ];

  meta = with lib; {
    description = "Baidu Cloud Engine Python SDK";
    homepage = "http://bce.baidu.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
