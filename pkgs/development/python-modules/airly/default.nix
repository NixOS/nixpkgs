{
  lib,
  aiohttp,
  aioresponses,
  aiounittest,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "airly";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ak-ambi";
    repo = "python-airly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-weliT/FYnRX+pzVAyRWFly7lfj2z7P+hpq5SIhyIgmI=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # aiounittest is not supported on 3.12
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    aioresponses
    aiounittest
    pytestCheckHook
  ];

  preCheck = ''
    cd tests
  '';

  pythonImportsCheck = [ "airly" ];

  meta = {
    description = "Python module for getting air quality data from Airly sensors";
    homepage = "https://github.com/ak-ambi/python-airly";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
