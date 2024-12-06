{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  iso8601,
  poetry-core,
  pytest-lazy-fixture,
  pytz,
}:

buildPythonPackage rec {
  pname = "beanhub-extract";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-extract";
    rev = "refs/tags/${version}";
    hash = "sha256-Uw9bSVOpiIALkgA77OrqAcDWcEafVSnp4iILa4Jkykc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    iso8601
    pytz
  ];

  nativeCheckInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beanhub_extract" ];

  meta = {
    description = "Simple library for extracting all kind of bank account transaction export files, mostly for beanhub-import to ingest and generate transactions";
    homepage = "https://github.com/LaunchPlatform/beanhub-extract/";
    changelog = "https://github.com/LaunchPlatform/beanhub-extract/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
