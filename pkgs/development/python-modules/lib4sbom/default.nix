{
  lib,
  buildPythonPackage,
  defusedxml,
  fastjsonschema,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  pyyaml,
  semantic-version,
  setuptools,
  xmlschema,
}:

buildPythonPackage rec {
  pname = "lib4sbom";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "lib4sbom";
    tag = "v${version}";
    hash = "sha256-GYXkxnZU7QYczKbJUiU+8TmboZQG9nkg00S1IRXeK6c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
    fastjsonschema
    jsonschema
    pyyaml
    semantic-version
    xmlschema
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
    changelog = "https://github.com/anthonyharrison/lib4sbom/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teatwig ];
  };
}
