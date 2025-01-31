{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  requests,
}:
buildPythonPackage rec {
  pname = "biothings-client";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biothings";
    repo = "biothings_client.py";
    rev = "v${version}";
    hash = "sha256-rCpzBX2H+7R8ulnJgtVlBA45ASa4DaY5jQ1bO2+bAC8=";
  };

  build-system = [ setuptools ];
  dependencies = [ requests ];
  pythonImportsCheck = [ "biothings_client" ];
  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # All other tests make network requests to exercise the API
    "tests/gene.py::TestGeneClient::test_http"
    "tests/test.py::TestBiothingsClient::test_generate_settings_from_url"
    "tests/variant.py::TestVariantClient::test_format_hgvs"
  ];

  meta = {
    changelog = "https://github.com/biothings/biothings_client.py/blob/v${version}/CHANGES.txt";
    description = "Wrapper to access Biothings.api-based backend services";
    homepage = "https://github.com/biothings/biothings_client.py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rayhem ];
  };
}
