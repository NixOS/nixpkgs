{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect-jffs";
  version = "1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.jffs";
    rev = "refs/tags/${version}";
    hash = "sha256-aElQR9QDC2110QZdk+PKkBky6FUXz9pSTJV7weTBvAE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  # Test file handling fails
  doCheck = true;

  pythonImportsCheck = [ "dissect.jffs" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the JFFS2 file system";
    homepage = "https://github.com/fox-it/dissect.jffs";
    changelog = "https://github.com/fox-it/dissect.jffs/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
