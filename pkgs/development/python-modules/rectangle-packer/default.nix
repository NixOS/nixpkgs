{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rectangle-packer";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Penlect";
    repo = "rectangle-packer";
    rev = version;
    hash = "sha256-BHFy88yrcfDRalvrzwUHseSKmQXIM70ginnd+W6LVLY=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "rpack" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -r rpack
  '';

<<<<<<< HEAD
  meta = {
    description = "Pack a set of rectangles into a bounding box with minimum area";
    homepage = "https://github.com/Penlect/rectangle-packer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbeffa ];
=======
  meta = with lib; {
    description = "Pack a set of rectangles into a bounding box with minimum area";
    homepage = "https://github.com/Penlect/rectangle-packer";
    license = licenses.mit;
    maintainers = with maintainers; [ fbeffa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
