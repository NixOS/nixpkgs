{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "opensimplex";
  version = "0.4.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lmas";
    repo = "opensimplex";
    rev = "v${version}";
    sha256 = "sha256-pxPak0H6Rh9KwhIsrnMvBFm1uF5XKb4B3H9cN6DM0g4=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "tests/test_opensimplex.py" ];
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
    maintainers = with maintainers; [ emilytrau ];
  };
}
