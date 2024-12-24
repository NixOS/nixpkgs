{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pytransportnsw";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PyTransportNSW";
    inherit version;
    sha256 = "00jklgjirmc58hiaqqc2n2rgixvx91bgrd6lv6hv28k51kid10f3";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "TransportNSW" ];

  meta = with lib; {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/Dav0815/TransportNSW";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
