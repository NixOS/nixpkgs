{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  pytak,
  aircot,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "adsbcot";
  version = "9.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snstac";
    repo = "adsbcot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pOSeWwNrqF4OGL/b6cz8W1+e+jz7ShmoF5WEcKl3y2E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytak
    aircot
    websockets
  ];

  pythonRelaxDeps = [ "websockets" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # broken upstream, see https://github.com/snstac/adsbcot/issues/61
    "test_adsb_to_cot_xml"
    "test_adsb_to_cot_with_known_craft"
  ];

  pythonImportsCheck = [ "adsbcot" ];

  meta = {
    description = "Display Aircraft in TAK - ADS-B to TAK Gateway";
    homepage = "https://adsbcot.readthedocs.io";
    changelog = "https://github.com/snstac/adsbcot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
