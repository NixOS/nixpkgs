{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyroaring";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ezibenroc";
    repo = "PyRoaringBitMap";
    tag = version;
    hash = "sha256-g+xpQ2DuVn8b0DiIOY69QOH6iwOYHG4bltX1zbDemdI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "cython>=3.0.2,<3.1.0" "cython"
  '';

  build-system = [
    (cython.overrideAttrs (rec {
      name = "cython";
      version = "3.0.12";
      src = fetchFromGitHub {
        owner = "cython";
        repo = "cython";
        tag = version;
        hash = "sha256-clJXjQb6rVECirKRUGX0vD5a6LILzPwNo7+6KKYs2pI=";
      };
    }))
    setuptools
  ];

  pythonImportsCheck = [ "pyroaring" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    description = "Python library for handling efficiently sorted integer sets";
    homepage = "https://github.com/Ezibenroc/PyRoaringBitMap";
    changelog = "https://github.com/Ezibenroc/PyRoaringBitMap/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
