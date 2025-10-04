{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  lxml,
  xlsxwriter,
  tqdm,
  requests,
  validators,
  wxpython,
  colorama,
  pyyaml,
  setuptools,
  kicost-digikey-api-v4,
  kicost-digikey-api-v3,
  distutils,
  xlsx2csv,
  unzip,
}:
buildPythonPackage rec {
  pname = "kicost";
  version = "1.1.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hildogjr";
    repo = "kicost";
    tag = "v${version}";
    hash = "sha256-2cJIiF8rZ0mHCO4aCTLTTazLBfGAlcj9u8HvRs5robs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "kicost" ];

  dependencies = [
    beautifulsoup4
    lxml
    xlsxwriter
    tqdm
    requests
    validators
    wxpython
    colorama
    pyyaml
    kicost-digikey-api-v4
    kicost-digikey-api-v3
    distutils
  ];

  meta = {
    description = "Build cost spreadsheets for a KiCAD project";
    homepage = "https://hildogjr.github.io/KiCost/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiranshila ];
  };
}
