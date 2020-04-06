{ lib
, buildPythonPackage, fetchPypi
, numpy, requests, six, pyglet, scipy, cloudpickle
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06h5b639nmzhmy4m1j3vigm86iv5pv7k8jy6xpldyd4jdlf37nn5";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyglet>=1.2.0,<=1.3.2" "pyglet"
  '';

  propagatedBuildInputs = [
    numpy requests six pyglet scipy cloudpickle
  ];

  # The test needs MuJoCo that is not free library.
  doCheck = false;

  meta = with lib; {
    description = "A toolkit by OpenAI for developing and comparing your reinforcement learning agents";
    homepage = "https://gym.openai.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
