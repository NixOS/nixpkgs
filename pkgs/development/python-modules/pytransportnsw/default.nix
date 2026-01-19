{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pytransportnsw";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyTransportNSW";
    inherit version;
    sha256 = "00jklgjirmc58hiaqqc2n2rgixvx91bgrd6lv6hv28k51kid10f3";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "TransportNSW" ];

  meta = {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/Dav0815/TransportNSW";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
