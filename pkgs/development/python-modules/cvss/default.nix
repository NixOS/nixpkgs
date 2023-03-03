{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cvss";
  version = "2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gD9MreJQPaxziy02Wt3BGFiIoQ/+pW3KqiNfNlTijJY=";
  };

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cvss"
  ];

  disabledTests = [
    # Tests require additional data
    "test_calculator"
    "test_cvsslib"
    "test_json_ordering"
    "test_json_schema_repr"
    "test_random"
    "test_rh_vector"
    "test_simple"
    "test_simple_31"
  ];

  meta = with lib; {
    description = "Library for CVSS2/3";
    homepage = "https://github.com/RedHatProductSecurity/cvss";
    changelog = "https://github.com/RedHatProductSecurity/cvss/releases/tag/v${version}";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
