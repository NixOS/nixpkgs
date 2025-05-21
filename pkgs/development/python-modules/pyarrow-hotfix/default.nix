{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyarrow-hotfix";
  version = "0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pitrou";
    repo = "pyarrow-hotfix";
    tag = "v${version}";
    hash = "sha256-9K7rQUSd+at1WghTP8DlD44Op2VkvN1vlzF3ZLEIaRE=";
  };

  nativeBuildInputs = [ hatchling ];

  pythonImportsCheck = [ "pyarrow_hotfix" ];

  meta = with lib; {
    description = "Hotfix for the PyArrow security vulnerability CVE-2023-47248";
    homepage = "https://github.com/pitrou/pyarrow-hotfix";
    changelog = "https://github.com/pitrou/pyarrow-hotfix/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
