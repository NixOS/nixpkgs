{ lib
, buildPythonPackage
, casttube
, fetchPypi
, pythonOlder
, protobuf
, requests
, zeroconf
}:

buildPythonPackage rec {
  pname = "pychromecast";
  version = "13.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyChromecast";
    inherit version;
    hash = "sha256-IDqvA3r7rKEnY6OpEZKd0lsKinse4A0BDTQ5vTGpglI=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "protobuf>=3.19.1,<4" "protobuf>=3.19.1"
  '';

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
    changelog = "https://github.com/home-assistant-libs/pychromecast/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
