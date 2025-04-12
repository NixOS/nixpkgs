{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  numpy,
  numpy_2,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gsd";
  version = "3.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "gsd";
    rev = "refs/tags/v${version}";
    hash = "sha256-sBO5tt85BVLUrqSVWUT/tYzeLWyvyyI9ZXjNLt9/uAE=";
  };

  build-system = [
    cython
    numpy_2
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
    changelog = "https://github.com/glotzerlab/gsd/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
