{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  poetry-core,
  pytz,
}:

buildPythonPackage rec {
  pname = "beanhub-extract";
  version = "0.0.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-extract";
    rev = "refs/tags/${version}";
    hash = "sha256-Wt8ZCyCaERNXEd0/Q89QWUW/wGFSHAP2RZLhnv5xkgY=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pytz ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "beanhub_extract" ];

  meta = {
    description = "The simple library for extracting all kind of bank account transaction export files, mostly for beanhub-import to ingest and generate transactions";
    homepage = "https://github.com/LaunchPlatform/beanhub-extract/";
    changelog = "https://github.com/LaunchPlatform/beanhub-extract/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
