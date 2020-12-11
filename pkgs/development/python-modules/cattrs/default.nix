{ lib
, buildPythonPackage
, fetchFromGitHub
, attrs
# Test inputs
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "cattrs";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "tinche";
    repo = "cattrs";
    rev = "v${version}";
    sha256 = "083d5mi6x7qcl26wlvwwn7gsp5chxlxkh4rp3a41w8cfwwr3h6l8";
  };

  propagatedBuildInputs = [ attrs ];

  checkInputs = [ pytestCheckHook hypothesis ];
  pytestFlagsArray = [
    "-v"
    "--durations=10"
  ];
  pythonImportsCheck = [ "cattr" ];
  disabledTests = [
    # Disable slowest tests to get build to < 5 mins
    "test_nested_roundtrip"
    "test_disambiguation"
    "test_union_field_roundtrip"
    "test_attrs_astuple_unstructure"
    "test_attrs_asdict_unstructure"
    "test_structure_union"
    "test_unmodified_generated_structuring"
    "test_nested_roundtrip"
    "test_omit_default_roundtrip"
    "test_structure_union_none"
    "test_type_overrides"
    "test_structure_union_explicit"
  ];

  meta = with lib; {
    description = "Complex custom class converters for attrs";
    homepage = "https://cattrs.readthedocs.io/en/latest/";
    changelog = "https://cattrs.readthedocs.io/en/latest/history.html";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
