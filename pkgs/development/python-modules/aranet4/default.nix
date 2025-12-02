{
  lib,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aranet4";
  version = "2.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Anrijs";
    repo = "Aranet4-Python";
    tag = "v${version}";
    hash = "sha256-/FBrP4aceIX9dcZmm+k13PSAPuK4SQenjWqOAFPSvL8=";
  };

  patches = [
    # https://github.com/Anrijs/Aranet4-Python/pull/62
    (fetchpatch {
      name = "fix-for-failing-test-with-bleak-1.1.0.patch";
      url = "https://github.com/Anrijs/Aranet4-Python/pull/62/commits/0117633682050c77cd00ead1bce93375367d7a3c.patch";
      hash = "sha256-S4Di6bKbapCpDdOIy4sSiG9dO7OZq5ixjjK+ux4EEp0=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    bleak
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aranet4" ];

  disabledTests = [
    # Test compares rendered output
    "test_current_values"
  ];

  meta = with lib; {
    description = "Module to interact with Aranet4 devices";
    homepage = "https://github.com/Anrijs/Aranet4-Python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "aranetctl";
  };
}
