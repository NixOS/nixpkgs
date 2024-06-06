{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pandas,
  pytestCheckHook,
  scipy,
  setuptools,
  sortedcontainers,
  typing-extensions,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pyannote-core";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-core";
    rev = "refs/tags/${version}";
    hash = "sha256-XQVEMy60LkfFr2TKXTeg6cGHRx5BUZ5qDgzIdKy/19Y=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    sortedcontainers
    numpy
    scipy
    typing-extensions
  ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyannote.core" ];

  meta = with lib; {
    description = "Advanced data structures for handling temporal segments with attached labels";
    homepage = "https://github.com/pyannote/pyannote-core";
    changelog = "https://github.com/pyannote/pyannote-core/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
