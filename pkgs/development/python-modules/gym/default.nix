{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, cloudpickle
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "v${version}";
    sha256 = "12b545xz0r2g4z5r7f8amxl7nm0lqymkzwcwhg1bni9h0sxwpv6c";
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
