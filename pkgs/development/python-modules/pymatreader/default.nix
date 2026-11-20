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
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pymatreader";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "obob";
    repo = "pymatreader";
    tag = "v${version}";
    hash = "sha256-UQI8bktmS+GycjbY1OHtS4OHT+Q3JyP8xvTbYIJJzC0=";
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

  # avoid autoupdates for *.dev* tags
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^([\\d.]+)$" ];
  };

  meta = {
    description = "Python package to read all kinds and all versions of Matlab mat files";
    homepage = "https://gitlab.com/obob/pymatreader/";
    changelog = "https://gitlab.com/obob/pymatreader/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
