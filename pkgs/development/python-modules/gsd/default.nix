{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gsd";
  version = "4.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "gsd";
    tag = "v${version}";
    hash = "sha256-qswKeZ8HJEjIV27O2UBmjN+Napa2sItECS5r/vb+l7k=";
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

  meta = with lib; {
    description = "General simulation data file format";
    mainProgram = "gsd";
    homepage = "https://github.com/glotzerlab/gsd";
    changelog = "https://github.com/glotzerlab/gsd/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
