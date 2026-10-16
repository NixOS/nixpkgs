{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py-ubjson";
  version = "0.16.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Iotic-Labs";
    repo = "py-ubjson";
    rev = "v${version}";
    hash = "sha256-Y5cKM3P0b68kXCnBCyGjMPoB2A2zbXuryx8h5fpJNrs=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/Iotic-Labs/py-ubjson/issues/18
    "test_recursion"
  ];

  enabledTestPaths = [ "test/test.py" ];

  pythonImportsCheck = [ "ubjson" ];

  meta = {
    description = "Universal Binary JSON draft-12 serializer for Python";
    homepage = "https://github.com/Iotic-Labs/py-ubjson";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
