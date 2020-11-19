{ lib
, buildPythonPackage, fetchPypi
, numpy, requests, six, pyglet, scipy, cloudpickle
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.17.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96a7dd4e9cdb39e30c7a79e5773570fd9408f7fdb58c714c293cfbb314818eb6";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyglet>=1.2.0,<=1.3.2" "pyglet" \
      --replace "cloudpickle>=1.2.0,<1.4.0" "cloudpickle~=1.2"
  '';
  # cloudpickle range has been expanded in package but not yet released

  propagatedBuildInputs = [
    numpy requests six pyglet scipy cloudpickle
  ];

  # The test needs MuJoCo that is not free library.
  doCheck = false;

  pythonImportsCheck = [ "gym" ];

  meta = with lib; {
    description = "A toolkit by OpenAI for developing and comparing your reinforcement learning agents";
    homepage = "https://gym.openai.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
