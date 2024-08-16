{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytestCheckHook,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "pyevtk";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyscience-projects";
    repo = "pyevtk";
    rev = "refs/tags/v${version}";
    hash = "sha256-HrodoVxjREZiutgRJ3ZUrART29+gAZfpR9f4A4SRh4Q=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'setup_requires=["pytest-runner"],' 'setup_requires=[],'
  '';

  build-system = [ setuptools ];
  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "pyevtk" ];

  meta = {
    description = "Exports data to binary VTK files for visualization/analysis";
    homepage = "https://github.com/pyscience-projects/pyevtk";
    changelog = "https://github.com/pyscience-projects/pyevtk/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
