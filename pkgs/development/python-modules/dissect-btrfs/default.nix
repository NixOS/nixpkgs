{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  google-crc32c,
  python-lzo,
  pythonOlder,
  setuptools,
  setuptools-scm,
  zstandard,
}:

buildPythonPackage rec {
  pname = "dissect-btrfs";
  version = "1.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.btrfs";
    tag = version;
    hash = "sha256-BREkGrQ1khz+uPahHeMwD0V8JytQY1K/oYa7nxP+bR0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  optional-dependencies = {
    full = [
      python-lzo
      zstandard
    ];
    gcrc32 = [ google-crc32c ];
  };

  # Issue with the test file handling
  doCheck = false;

  pythonImportsCheck = [ "dissect.btrfs" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the BTRFS file system";
    homepage = "https://github.com/fox-it/dissect.btrfs";
    changelog = "https://github.com/fox-it/dissect.btrfs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
