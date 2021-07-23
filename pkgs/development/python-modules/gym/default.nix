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
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = version;
    sha256 = "sha256-10KHUG6WacYzqna97vEhSQWDmJDvDmD5QxLhPW5NQSs=";
  };

  propagatedBuildInputs = [
    cloudpickle
    numpy
    pillow
    pyglet
    requests
    scipy
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "Pillow<=8.2.0" "Pillow"
  '';

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
