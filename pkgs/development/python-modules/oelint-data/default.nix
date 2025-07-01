{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  oelint-parser,
}:

buildPythonPackage rec {
  pname = "oelint-data";
  version = "1.0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-data";
    tag = version;
    hash = "sha256-vaQ+ZX+kTIrgFNDHQ5DPFMmH+GiSWG5pgy+7/yuMVw4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    oelint-parser
  ];

  pythonImportsCheck = [ "oelint_data" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Data for oelint-adv";
    homepage = "https://github.com/priv-kweihmann/oelint-data";
    changelog = "https://github.com/priv-kweihmann/oelint-data/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
