{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  yarl,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "openwebifpy";
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FaynJT+bR63nIwLEwXjTjwPXZ3Q5/X+zpx0gTA3Pqo8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "openwebif" ];

  disabledTests = [
    # https://github.com/autinerd/openwebifpy/issues/1
    "test_get_picon_name"
  ];

  meta = with lib; {
    description = "Provides a python interface to interact with a device running OpenWebIf";
    downloadPage = "https://github.com/autinerd/openwebifpy";
    homepage = "https://openwebifpy.readthedocs.io/";
    changelog = "https://github.com/autinerd/openwebifpy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
