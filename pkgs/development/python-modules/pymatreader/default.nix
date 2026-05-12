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
  version = "1.2.3.dev0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "obob";
    repo = "pymatreader";
    tag = "v${version}";
    hash = "sha256-yrbWtJd6Rod/Au4FvzA+sXtybkz6+9eVh/5qfAHUdEw=";
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

  meta = {
    description = "Python package to read all kinds and all versions of Matlab mat files";
    homepage = "https://gitlab.com/obob/pymatreader/";
    changelog = "https://gitlab.com/obob/pymatreader/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
