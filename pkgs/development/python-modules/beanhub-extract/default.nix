{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  pytestCheckHook,
  iso8601,
  pytest-lazy-fixture,
  pytz,
}:

buildPythonPackage rec {
  pname = "beanhub-extract";
<<<<<<< HEAD
  version = "0.1.7";
=======
  version = "0.1.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-extract";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-CpR4NNXr6Ag8dCI+NB+4hvAtFBjKJTNkXMps2E+6L7Q=";
=======
    hash = "sha256-N4LCMZRPbIzVUPDCW3mAVw6WwpuvxiJmMIoyk8VwXS0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "pytz" ];

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
    changelog = "https://github.com/LaunchPlatform/beanhub-extract/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
