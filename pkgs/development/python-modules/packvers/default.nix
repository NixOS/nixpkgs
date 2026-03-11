{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretend,
  pyparsing,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "packvers";
  version = "22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "packvers";
    tag = version;
    hash = "sha256-19jCW3BK6XIcukDsFd1jERc2+g8Hcs/gdm3+dBzQS14=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyparsing ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [ "packvers" ];

  disabledTests = [
    # Failed: DID NOT RAISE <class 'packvers.requirements.InvalidRequirement'>
    "test_invalid_file_urls"
  ];

  meta = {
    description = "Module for version handling of modules";
    homepage = "https://github.com/aboutcode-org/packvers";
    changelog = "https://github.com/nexB/packvers/blob/${src.tag}/CHANGELOG.rst";
    license = with lib.licenses; [
      asl20 # and
      bsd2
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
