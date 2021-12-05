{ lib, buildPythonPackage, casttube, fetchPypi, isPy3k, protobuf, requests
, zeroconf }:

buildPythonPackage rec {
  pname = "pychromecast";
  version = "10.1.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "PyChromecast";
    inherit version;
    sha256 = "sha256-M6R9VRrotvkxKVZIKOcuf03LJsn4gSMohwzzAO5FQ48=";
  };

  propagatedBuildInputs = [ casttube protobuf requests zeroconf ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [ "pychromecast" ];

  meta = with lib; {
    description =
      "Library for Python to communicate with the Google Chromecast";
    homepage = "https://github.com/home-assistant-libs/pychromecast";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
