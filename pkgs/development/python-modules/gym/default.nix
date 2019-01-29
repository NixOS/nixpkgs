{ lib
, buildPythonPackage, fetchPypi
, numpy, requests, six, pyglet, scipy
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.10.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1id2xyyypks8bjdayb19av809w0838ghymyngmyhdbbsk588q7q0";
  };

  propagatedBuildInputs = [
    numpy requests six pyglet scipy
  ];

  # The test needs MuJoCo that is not free library.
  doCheck = false;

  meta = with lib; {
    description = "A toolkit by OpenAI for developing and comparing your reinforcement learning agents";
    homepage = https://gym.openai.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
