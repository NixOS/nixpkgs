{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretend,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "packvers";
  version = "21.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "packvers";
    tag = version;
    hash = "sha256-nCSYL0g7mXi9pGFt24pOXbmmYsaRuB+rRZrygf8DTLE=";
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

  meta = with lib; {
    description = "Module for version handling of modules";
    homepage = "https://github.com/aboutcode-org/packvers";
    changelog = "https://github.com/nexB/packvers/blob/${version}/CHANGELOG.rst";
    license = with licenses; [
      asl20 # and
      bsd2
    ];
    maintainers = with maintainers; [ fab ];
  };
}
