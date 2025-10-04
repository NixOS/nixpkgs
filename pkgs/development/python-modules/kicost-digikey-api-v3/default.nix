{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  inflection,
  setuptools,
  requests,
  urllib3,
  six,
  certifi,
  pyopenssl,
  tldextract,
  python-dateutil,
  distutils,
}:
buildPythonPackage rec {
  pname = "kicost-digikey-api-v3";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "set-soft";
    repo = "kicost-digikey-api-v3";
    tag = "v${version}";
    hash = "sha256-O4bYvf8EnAlcgJ/fqYEuo2+37Q6lTdmlSrmaD2Cl/q8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "kicost_digikey_api_v3" ];

  dependencies = [
    inflection
    requests
    urllib3
    six
    certifi
    pyopenssl
    tldextract
    python-dateutil
    distutils
  ];

  meta = {
    description = "KiCost plugin for the Digikey PartSearch API V3 ";
    homepage = "https://github.com/set-soft/kicost-digikey-api-v3";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kiranshila ];
  };
}
