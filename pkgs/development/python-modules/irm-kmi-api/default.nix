{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  svgwrite,
}:

buildPythonPackage rec {
  pname = "irm-kmi-api";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdejaegh";
    repo = "irm-kmi-api";
    tag = version;
    hash = "sha256-E8lf2TpeA91mRbxXYCsuum0mJdE5XLXX0l8CKEl5SFw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    svgwrite
  ];

  pythonImportsCheck = [ "irm_kmi_api" ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jdejaegh/irm-kmi-api/releases/tag/${src.tag}";
    description = "Retrieve data from the Belgian Royal Meteorological Institute";
    homepage = "https://github.com/jdejaegh/irm-kmi-api";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
