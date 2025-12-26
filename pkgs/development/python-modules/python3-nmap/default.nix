{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  simplejson,
}:

buildPythonPackage rec {
  pname = "python3-nmap";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nmmapper";
    repo = "python3-nmap";
    tag = version;
    hash = "sha256-d/rH3aRNh9SDyVvbiTFCQyfZ6amtnH2iSwKqTOlVLNY=";
  };

  build-system = [ setuptools ];

  dependencies = [ simplejson ];

  pythonImportsCheck = [ "nmap3" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Library which helps in using nmap port scanner";
    homepage = "https://github.com/nmmapper/python3-nmap";
    changelog = "https://github.com/nmmapper/python3-nmap/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
