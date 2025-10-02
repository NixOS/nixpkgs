{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect-cramfs";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cramfs";
    tag = version;
    hash = "sha256-0BHt7v2sI9uxZFUVsTkPZHy+wC6twaHeBmgH04anmp0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  # Issue with the test file handling
  doCheck = false;

  pythonImportsCheck = [ "dissect.cramfs" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the CRAMFS file system";
    homepage = "https://github.com/fox-it/dissect.cramfs";
    changelog = "https://github.com/fox-it/dissect.crmfs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
