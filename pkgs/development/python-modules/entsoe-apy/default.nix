{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  isodate,
  httpx,
  loguru,
  xsdata-pydantic,
}:

buildPythonPackage rec {
  pname = "entsoe-apy";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "berrij";
    repo = "entsoe-apy";
    tag = "v${version}";
    hash = "sha256-tHduOA3huBuCm/ygFcgmtYQ2AZkco9oy7yVRnYpB/K0=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    httpx
    loguru
    xsdata-pydantic
    isodate
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "entsoe"
  ];

  meta = {
    description = "Python Package to Query the ENTSO-E API";
    homepage = "https://github.com/berrij/entsoe-apy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ berrij ];
    platforms = lib.platforms.all;
  };
}
