{
  lib,
  buildPythonPackage,
  fetchFromForgejo,
  setuptools,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "opensimplex";
  version = "0.4.5.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "code.larus.se";
    owner = "lmas";
    repo = "opensimplex";
    rev = "v${finalAttrs.version}";
    forceFetchGit = true;
    sha256 = "sha256-pM/vazhFfMip4G31Zj6jv02lEGVYymYCpCVz6sGBwVw=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "tests/test_opensimplex.py" ];
  pythonImportsCheck = [ "opensimplex" ];

  meta = {
    description = "OpenSimplex Noise functions for 2D, 3D and 4D";
    longDescription = ''
      OpenSimplex noise is an n-dimensional gradient noise function that was
      developed in order to overcome the patent-related issues surrounding
      Simplex noise, while continuing to also avoid the visually-significant
      directional artifacts characteristic of Perlin noise.
    '';
    homepage = "https://github.com/lmas/opensimplex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
})
