{ lib
, buildPythonPackage
, casttube
, fetchPypi
, isPy3k
, protobuf
, requests
, zeroconf
}:

buildPythonPackage rec {
  pname = "pychromecast";
  version = "10.2.3";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "PyChromecast";
    inherit version;
    sha256 = "ddb86c5acdc13e8bdadd2b7f5738fda36b32c1750548f7b629ca8d178f05e0da";
  };

  propagatedBuildInputs = [
    casttube
    protobuf
    requests
    zeroconf
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [
    "pychromecast"
  ];

  meta = with lib; {
    description = "Library for Python to communicate with the Google Chromecast";
    homepage = "https://github.com/home-assistant-libs/pychromecast";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
