{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyownet";
  version = "0.10.0.post1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f2fa4471c2f806b35090bdc6c092305c6eded3ff3736f8b586d35bdb157de62";
  };

  # tests access network
  doCheck = false;

  pythonImportsCheck = [ "pyownet.protocol" ];

  meta = with lib; {
    description = "Python OWFS client library (owserver protocol)";
    homepage = "https://github.com/miccoli/pyownet";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
