{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, cloudpickle
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = version;
    sha256 = "sha256-JbPWLuQGo+fErUlCKKpMwWdu0KvXBDuH2MeAHdJCTgM=";
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
