{ buildPythonPackage, fetchPypi, lib, pulsectl, pythonOlder }:

buildPythonPackage rec {
  pname = "pulsectl-asyncio";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qBMIH/HOnt9SXrnrGtZTG4fOb0fftR7mBaU7K4mcYvo=";
  };

  disabled = pythonOlder "3.6";
  propagatedBuildInputs = [ pulsectl ];
  pythonImportsCheck = [ "pulsectl_asyncio" ];

  meta = with lib; {
    homepage = "https://github.com/mhthies/pulsectl-asyncio";
    description =
      "A Python 3 asyncio interface on top of the pulsectl library for monitoring and controlling the PulseAudio sound server";
    license = licenses.mit;
    maintainers = with maintainers; [ remexre ];
  };
}
