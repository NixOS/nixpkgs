{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  yarl,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "openwebifpy";
  version = "4.2.7";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MoTSfoO6km3jAaF9oIDxhxhMI8jqZAyPD6yBYcYxhd4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
