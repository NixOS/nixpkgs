{ lib
, buildPythonPackage, fetchPypi
, numpy, requests, six, pyglet, scipy
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.12.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90f53ec8291063abb4654eddeaac2a3a23152438a38c39830d3a3f3fc6a7ca59";
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
