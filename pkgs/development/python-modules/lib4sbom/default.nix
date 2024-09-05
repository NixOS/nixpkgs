{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  semantic-version,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lib4sbom";
  version = "0.7.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "lib4sbom";
    rev = "refs/tags/v${version}";
    hash = "sha256-Uqv6E9qMJRsfYICVAiZEQGlG/0w8aECuh8wMa85FnlE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
    pyyaml
    semantic-version
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # stub tests that always fail
    "TestCycloneDXGenerator"
    "TestCcycloneDX_parser"
    "TestGenerator"
    "TestOutput"
    "TestParser"
    "TestSPDX_Generator"
    "TestSPDX_Parser"
    # tests with missing getters
    "test_set_downloadlocation"
    "test_set_homepage"
    "test_set_checksum"
    "test_set_externalreference"
    # checks for invalid return type
    "test_set_type"
    # wrong capilatization
    "test_set_supplier"
    "test_set_originator"
  ];

  pythonImportsCheck = [ "lib4sbom" ];

  meta = with lib; {
    description = "Library to ingest and generate SBOMs";
    homepage = "https://github.com/anthonyharrison/lib4sbom";
    changelog = "https://github.com/anthonyharrison/lib4sbom/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teatwig ];
  };
}
