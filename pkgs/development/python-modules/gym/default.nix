{ lib
, buildPythonPackage, fetchPypi
, numpy, requests, six, pyglet, scipy
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0llbhn3zdlsz2crd5grd1yygg8zp2shsclc24iqix5gw5f65clx5";
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
