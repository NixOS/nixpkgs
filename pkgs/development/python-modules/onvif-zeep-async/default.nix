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
  version = "4.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openvideolibs";
    repo = "python-onvif-zeep-async";
    tag = "v${version}";
    hash = "sha256-1reP3BKfFh45L2WUrXS3e/DX22oZTMS6AwVlz6JHFAU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    ciso8601
    yarl
    zeep
  ]
  ++ zeep.optional-dependencies.async;

  pythonImportsCheck = [ "onvif" ];

  # Tests are not shipped
  doCheck = false;

  meta = with lib; {
    description = "ONVIF Client Implementation in Python";
    homepage = "https://github.com/hunterjm/python-onvif-zeep-async";
    changelog = "https://github.com/openvideolibs/python-onvif-zeep-async/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "onvif-cli";
  };
}
