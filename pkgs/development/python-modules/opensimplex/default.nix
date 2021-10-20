{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
}:

buildPythonPackage rec {
  pname = "opensimplex";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "lmas";
    repo = pname;
    rev = "v${version}";
    sha256 = "idF5JQGnAye6z3c3YU9rsHaebB3rlHJfA8vSpjDnFeM=";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests tests/
  '';
  pythonImportsCheck = [ "opensimplex" ];

  meta = with lib; {
    description = "OpenSimplex Noise functions for 2D, 3D and 4D";
    longDescription = ''
      OpenSimplex noise is an n-dimensional gradient noise function that was
      developed in order to overcome the patent-related issues surrounding
      Simplex noise, while continuing to also avoid the visually-significant
      directional artifacts characteristic of Perlin noise.
    '';
    homepage = "https://github.com/lmas/opensimplex";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ angustrau ];
  };
}
