{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysomfymylink";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sslivins";
    repo = "pysomfymylink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QIvxp+hszvzYBqjUeuGTpFfJRXwnpo2SVbi49Uh+8Zs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysomfymylink" ];

  meta = {
    description = "Async Python client for the Somfy MyLink Synergy socket API (a maintained rewrite of somfy-mylink-synergy)";
    homepage = "https://github.com/sslivins/pysomfymylink";
    changelog = "https://github.com/sslivins/pysomfymylink/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
