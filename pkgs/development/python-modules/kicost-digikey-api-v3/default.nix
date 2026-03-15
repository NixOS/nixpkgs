{
  buildPythonPackage,
  certifi,
  distutils,
  fetchFromGitHub,
  inflection,
  lib,
  pyopenssl,
  python-dateutil,
  setuptools,
  six,
  tldextract,
  requests,
  urllib3,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "kicost-digikey-api-v3";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "set-soft";
    repo = "kicost-digikey-api-v3";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-O4bYvf8EnAlcgJ/fqYEuo2+37Q6lTdmlSrmaD2Cl/q8=";
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

  doCheck = true;
  pythonImportsCheck = [ "kicost_digikey_api_v3" ];

  meta = {
    description = "KiCost plugin for the Digikey PartSearch API v3";
    homepage = "https://github.com/set-soft/kicost-digikey-api-v3";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
