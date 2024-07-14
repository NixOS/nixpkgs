{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  opencv4,
}:

buildPythonPackage rec {
  pname = "pyfakewebcam";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KtjOraZgXYumunbgh+3yC/ziLVRPxBABMGfXzjR9VpQ=";
  };

  propagatedBuildInputs = [
    numpy
    opencv4
  ];

  # No tests are available
  doCheck = false;
  pythonImportsCheck = [ "pyfakewebcam" ];

  meta = with lib; {
    description = "Library for writing RGB frames to a fake webcam device on Linux";
    homepage = "https://github.com/jremmons/pyfakewebcam";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.linux;
  };
}
