{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, cloudpickle
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-pswKeeLV7tnY/MFDBBQhQX3Nx2wvs5s7b44FYhxKALs=";
  };

  propagatedBuildInputs = [
    cloudpickle
    numpy
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
