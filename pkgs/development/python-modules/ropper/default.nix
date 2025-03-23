{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  capstone,
  filebytes,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ropper";
  version = "1.13.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sashs";
    repo = "Ropper";
    rev = "v${version}";
    hash = "sha256-yuHJ+EpglumEAXEu0iJKIXK1ouW1yptNahM9Wmk7AW4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    capstone
    filebytes
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ropper" ];

  meta = with lib; {
    description = "Show information about files in different file formats";
    mainProgram = "ropper";
    homepage = "https://scoding.de/ropper/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
