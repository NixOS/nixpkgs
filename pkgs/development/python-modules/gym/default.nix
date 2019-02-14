{ lib
, buildPythonPackage, fetchPypi
, numpy, requests, six, pyglet, scipy
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9c79fc295b8b20cfda5ab0a671e72c95615dc77517ae414f8f8b10e9375f155";
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
