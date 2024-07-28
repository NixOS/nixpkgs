{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
  semantic-version,
  defusedxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lib4sbom";
  version = "0.7.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sjfOCG1E5Of+HPcfRsBwEKmGkhUOIkAARWja81FL2PY=";
  };

  dependencies = [
    pyyaml
    semantic-version
    defusedxml
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
    license = licenses.asl20;
    maintainers = with maintainers; [ teatwig ];
  };
}
