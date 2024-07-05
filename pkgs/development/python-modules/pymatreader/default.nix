{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  h5py,
  numpy,
  scipy,
  xmltodict,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymatreader";
  version = "0.0.31";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "obob";
    repo = "pymatreader";
    rev = "refs/tags/v${version}";
    hash = "sha256-pYObmvqA49sHjpZcwXkN828R/N5CSpmr0OyyxzDiodQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    h5py
    numpy
    scipy
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pymatreader" ];

  meta = with lib; {
    description = "Python package to read all kinds and all versions of Matlab mat files";
    homepage = "https://gitlab.com/obob/pymatreader/";
    changelog = "https://gitlab.com/obob/pymatreader/-/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
