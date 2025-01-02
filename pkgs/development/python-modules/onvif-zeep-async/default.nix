{
  lib,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  httpx,
  pythonOlder,
  setuptools,
  zeep,
}:

buildPythonPackage rec {
  pname = "onvif-zeep-async";
  version = "3.1.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openvideolibs";
    repo = "python-onvif-zeep-async";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z9LtKcgyebmdrChRz0QwiQdnrtcIVeCtKQAvL9gBMY4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ciso8601
    httpx
    zeep
  ];

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
