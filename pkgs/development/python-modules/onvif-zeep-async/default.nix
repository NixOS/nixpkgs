{
  lib,
  aiohttp,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  yarl,
  zeep,
}:

buildPythonPackage rec {
  pname = "onvif-zeep-async";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openvideolibs";
    repo = "python-onvif-zeep-async";
    tag = "v${version}";
    hash = "sha256-adEU/SAJac1sOCZS0xb64T41Eak7/uxh6aq2xKUgjZ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    ciso8601
    yarl
    zeep
  ] ++ zeep.optional-dependencies.async;

  pythonImportsCheck = [ "onvif" ];

  # Tests are not shipped
  doCheck = false;

  meta = with lib; {
    description = "ONVIF Client Implementation in Python";
    homepage = "https://github.com/hunterjm/python-onvif-zeep-async";
    changelog = "https://github.com/openvideolibs/python-onvif-zeep-async/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "onvif-cli";
  };
}
