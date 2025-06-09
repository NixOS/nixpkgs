{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  hatchling,
  h5py,
  numpy,
  scipy,
  xmltodict,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymatreader";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "obob";
    repo = "pymatreader";
    tag = "v${version}";
    hash = "sha256-cDEGEvBSj3gmjA+8aXULwuBVk09BLQbA91CNAxgtiLA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'source = "regex_commit"' "" \
      --replace-fail '"hatch-regex-commit"' ""
  '';

  build-system = [ hatchling ];

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
