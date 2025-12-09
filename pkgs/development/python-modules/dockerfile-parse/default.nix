{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dockerfile-parse";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MYTM3FEyIZg+UDrADhqlBKKqj4Tl3mc8RrC27umex7w=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dockerfile_parse" ];

  disabledTests = [
    # python-dockerfile-parse.spec is not present
    "test_all_versions_match"
  ];

  meta = with lib; {
    description = "Library for parsing Dockerfile files";
    homepage = "https://github.com/DBuildService/dockerfile-parse";
    changelog = "https://github.com/containerbuildsystem/dockerfile-parse/releases/tag/${version}";
    license = licenses.bsd3;
  };
}
