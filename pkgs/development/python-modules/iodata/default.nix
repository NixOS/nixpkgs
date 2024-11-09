{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  scipy,
  attrs,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "iodata";
  version = "1.0.0a4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theochem";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ld6V+/8lg4Du6+mHU5XuXXyMpWwyepXurerScg/bf2Q=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
    attrs
  ];

  pythonImportsCheck = [ "iodata" ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python library for reading, writing, and converting computational chemistry file formats and generating input files";
    mainProgram = "iodata-convert";
    homepage = "https://github.com/theochem/iodata";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
