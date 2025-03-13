{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # buildInputs
  libffi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyobjus";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kivy";
    repo = "pyobjus";
    tag = "v${version}";
    hash = "sha256-8abbxskM3uNNLVKP4Hp6xA9Z45pNNJQKShu+4lj1+4A=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [
    libffi
  ];

  pythonImportsCheck = [ "pyobjus" ];

  preCheck = ''
    rm -rf pyobjus
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Access Objective-C classes from Python";
    homepage = "https://github.com/kivy/pyobjus";
    changelog = "https://github.com/kivy/pyobjus/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
