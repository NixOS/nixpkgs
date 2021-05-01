{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, requests
, pyglet
, scipy
, pillow
, cloudpickle
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = version;
    sha256 = "0mv4af2y9d1y97bsda94f21nis2jm1zkzv7c806vmvzh5s4r8nfn";
  };

  propagatedBuildInputs = [
    cloudpickle
    numpy
    pillow
    pyglet
    requests
    scipy
  ];

  # The test needs MuJoCo that is not free library.
  doCheck = false;

  pythonImportsCheck = [ "gym" ];

  meta = with lib; {
    description = "A toolkit for developing and comparing your reinforcement learning agents";
    homepage = "https://gym.openai.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
