{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build-system
  setuptools,

  # dependencies
  asgiref,
  httpx,
  pydantic,
  requests,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  responses,
  respx,
}:

buildPythonPackage rec {
  pname = "mixpanel";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mixpanel";
    repo = "mixpanel-python";
    tag = "v${version}";
    hash = "sha256-Q8Kn2dyID1hYjKmEv0e+R/y5dsp/JEkqCdNqQHJsOrI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    httpx
    pydantic
    requests
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    responses
    respx
  ];

  meta = {
    homepage = "https://github.com/mixpanel/mixpanel-python";
    description = "Official Mixpanel Python library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
