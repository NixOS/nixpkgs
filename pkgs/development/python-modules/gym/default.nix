{ lib
, buildPythonPackage, fetchPypi
, numpy, requests, six, pyglet, scipy
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.15.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18381e13bbd1e2f206a1b88a2af4fb87affd7d06ee7955a6e5e6a79478a9adfc";
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
