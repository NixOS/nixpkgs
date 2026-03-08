{
  buildPythonPackage,
  certifi,
  distutils,
  fetchFromGitHub,
  inflection,
  lib,
  pyopenssl,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  six,
  tldextract,
  requests,
  urllib3,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "kicost-digikey-api-v4";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "set-soft";
    repo = "kicost-digikey-api-v4";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-0IpimgrxguI8Y7mwrHpG42bvbWPR/dukFRicbz3Olow=";
  };

  build-system = [
    setuptools
    wheel
  ];

  # Dependencies as specified in setup.py
  dependencies = [
    certifi
    distutils
    inflection
    pyopenssl
    python-dateutil
    requests
    six
    tldextract
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook

  ];

  # Add this block to skip the test file that requires external config
  pytestFlagsArray = [
    "--ignore=test_production.py"
  ];

  # Disable pytest because the only available tests require external config/network
  doCheck = false;
  pythonImportsCheck = [ "kicost_digikey_api_v4" ];

  meta = {
    changelog = "https://github.com/set-soft/kicost-digikey-api-v3/releases/tag/v${finalAttrs.src.tag}";
    description = "KiCost plugin for the Digikey PartSearch API V4";
    homepage = "https://github.com/set-soft/kicost-digikey-api-v4";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
