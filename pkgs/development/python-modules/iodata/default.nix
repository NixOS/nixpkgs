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

buildPythonPackage (finalAttrs: {
  pname = "qc-iodata";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theochem";
    repo = "iodata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ly5nEqgxCt5uU+UNQx/7zgrh+w1Plngarw29+Ns68ts=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
      'addopts = "-n auto -W error --strict-markers"' \
      'addopts = "-n auto --strict-markers"'
  '';

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

  disabledTestPaths = [ "tools/test_harmonics.py" ];

  meta = {
    description = "Python library for reading, writing, and converting computational chemistry file formats and generating input files";
    mainProgram = "iodata-convert";
    homepage = "https://github.com/theochem/iodata";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
