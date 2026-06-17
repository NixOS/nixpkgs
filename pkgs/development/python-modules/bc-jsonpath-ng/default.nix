{
  lib,
  buildPythonPackage,
  decorator,
  fetchFromGitHub,
  ply,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bc-jsonpath-ng";
  version = "1.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "jsonpath-ng";
    tag = version;
    hash = "sha256-FWP4tzlacAWVXG3YnPwl5MKc12geaCxZ2xyKx9PSarU=";
  };

  propagatedBuildInputs = [
    decorator
    ply
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Exclude tests that require oslotest
    "tests/test_jsonpath_rw_ext.py"
  ];

  pythonImportsCheck = [ "bc_jsonpath_ng" ];

  meta = {
    description = "JSONPath implementation for Python";
    mainProgram = "bc_jsonpath_ng";
    homepage = "https://github.com/bridgecrewio/jsonpath-ng";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
