{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gsd";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "gsd";
    tag = "v${version}";
    hash = "sha256-8pEs1use/R7g0l6h+rxjpN5j8PznqkJpjLxqiupn9iY=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gsd" ];

  preCheck = ''
    pushd gsd/test
  '';

  postCheck = ''
    popd
  '';

  meta = {
    description = "General simulation data file format";
    mainProgram = "gsd";
    homepage = "https://github.com/glotzerlab/gsd";
    changelog = "https://github.com/glotzerlab/gsd/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
