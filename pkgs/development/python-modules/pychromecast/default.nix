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
  version = "10.2.2";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "PyChromecast";
    inherit version;
    sha256 = "bd1dbb9383ed549d42d12f337a6c664a9088b4910ebb3f11de6fe15f397e7efd";
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
